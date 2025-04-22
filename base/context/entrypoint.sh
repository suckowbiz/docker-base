#!/usr/bin/env bash
#
# Sets up a given user environment and starts the given application on behalf of the given user to ensure proper read and write to mounted files.
#
# Globals
#   GIVEN_USER                      Name of host system user.
#   GIVEN_USER_ID                   ID of host system user.
#   GIVEN_USER_GROUP                Group name of host system user.
#   GIVEN_USER_GROUP_ID             Group ID of host system user.
#   GIVEN_USER_BUILT_IN_GROUPS      (Optional) Name of groups (expected to exist in the container already) to add the user to .
#   GIVEN_USER_ADDITIONAL_GROUP     (Optional) Name of new addtional group to create for the user.
#   GIVEN_USER_ADDITIONAL_GROUP_ID  (Optional) ID of new addtional group to create for the user.
#   ENTRYPOINT_WORKDIR              (Optional) Initial WORKDIR for application execution 
set -e

#######################################
# Checks if a specified environment variable is set and not empty.
# Globals:
#   None
# Arguments:
#   1: Name of the environment variable to check.
# Outputs:
#   Writes an error message to STDERR if the variable is unset or empty.
# Returns:
#   Exits with status 1 if the variable is unset or empty.
#######################################
require_env_var() {
  local var_name="$1"
  if [ -z "${!var_name:-}" ]; then
    echo "ERROR: Environment variable '$var_name' is not set or empty." >&2
    exit 1
  fi
}

require_env_var "GIVEN_USER"
require_env_var "GIVEN_USER_ID"
require_env_var "GIVEN_USER_GROUP"
require_env_var "GIVEN_USER_GROUP_ID"


[[ "$GIVEN_USER_ID" =~ ^[0-9]+$ ]] || {
    echo "ERROR: GIVEN_USER_ID must be numeric." >&2
    exit 1
}

# Create the user group to provide the same group as on host system.
group_entry=$(getent group "${GIVEN_USER_GROUP}")
if [[ -n "$group_entry" ]]; then
    existing_gid=$(echo "$group_entry" | cut -d: -f3)
    if [[ "$existing_gid" == "${GIVEN_USER_GROUP_ID}" ]]; then
        echo "INFO: Group '${GIVEN_USER_GROUP}' with GID '${GIVEN_USER_GROUP_ID}' already exists."
    else
        echo "ERROR: Group '${GIVEN_USER_GROUP}' exists with a different GID (${existing_gid})." >&2
        exit 1
    fi
else
    if ! groupadd --gid "${GIVEN_USER_GROUP_ID}" "${GIVEN_USER_GROUP}"; then
        echo "Error: Failed to create group '${GIVEN_USER_GROUP}' with GID '${GIVEN_USER_GROUP_ID}'." >&2
        exit 1
    fi
    echo "INFO: Group '${GIVEN_USER_GROUP}' with GID '${GIVEN_USER_GROUP_ID}' created successfully."
fi

# Create the user to provide environment and same name as on host system.
if id -u "${GIVEN_USER}" &>/dev/null; then
    existing_uid=$(id -u "${GIVEN_USER}")
    if [[ "${existing_uid}" != "${GIVEN_USER_ID}" ]]; then
        echo "ERROR: User '${GIVEN_USER}' exists with UID '${existing_uid}', expected UID '${GIVEN_USER_ID}'." >&2
        exit 1
    fi
else
    # Create the user with specified UID and GID to provide the user object.
    if ! useradd --create-home --uid "${GIVEN_USER_ID}" --gid "${GIVEN_USER_GROUP_ID}" "${GIVEN_USER}"; then
        echo "ERROR: Failed to create user '${GIVEN_USER}' with UID '${GIVEN_USER_ID}' and GID '${GIVEN_USER_GROUP_ID}'." >&2
        exit 1
    fi

    # Add user to additional groups if specified to complete user setup.
    if [[ -n "${GIVEN_USER_BUILT_IN_GROUPS}" ]]; then
        if ! usermod -a -G "${GIVEN_USER_BUILT_IN_GROUPS}" "${GIVEN_USER}"; then
            echo "ERROR: Failed to add user '${GIVEN_USER}' to groups '${GIVEN_USER_BUILT_IN_GROUPS}'." >&2
            exit 1
        fi
    fi
# Create and assign additional group if specified
if [ -n "${GIVEN_USER_ADDITIONAL_GROUP_ID:-}" ] && [ -n "${GIVEN_USER_ADDITIONAL_GROUP:-}" ]; then
  if ! getent group "$GIVEN_USER_ADDITIONAL_GROUP" >/dev/null; then
    if ! groupadd --gid "$GIVEN_USER_ADDITIONAL_GROUP_ID" "$GIVEN_USER_ADDITIONAL_GROUP"; then
      echo "ERROR: Failed to create additional group '$GIVEN_USER_ADDITIONAL_GROUP' with GID '$GIVEN_USER_ADDITIONAL_GROUP_ID'." >&2
      exit 1
    fi
    echo "INFO: Additional group '$GIVEN_USER_ADDITIONAL_GROUP' with GID '$GIVEN_USER_ADDITIONAL_GROUP_ID' created successfully."
  fi
  usermod -a -G "$GIVEN_USER_ADDITIONAL_GROUP" "$GIVEN_USER"
  echo "INFO: Added user '$GIVEN_USER' to additional group '$GIVEN_USER_ADDITIONAL_GROUP'."
fi
fi
# If the user is root (UID 0), copy default skeleton files to /root to provide all required setup.
if [[ "${GIVEN_USER_ID}" == "0" ]]; then
    if ! cp --recursive --no-dereference /etc/skel/. /root/; then
        echo "ERROR: Failed to copy skeleton files to /root." >&2
        exit 1
    fi
fi

if [[ ! "${ENTRYPOINT_WORKDIR}" = "" ]]; then
    # Intentionally added to set a WORKDIR on Container start.
    cd "${ENTRYPOINT_WORKDIR}"
fi

# 'gosu' is used to run the executable on behalf of the just created user. It is preferred over sudo
# in containers as it avoids TTY and signal-forwarding issues.
# 'exec' is used to run it with PID 1 to ensure graceful shutdown when process is exited.
# This approach is recommended for PID 1 processes in containers
exec gosu "${GIVEN_USER_ID}" "$@"
