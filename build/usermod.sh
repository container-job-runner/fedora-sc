#! /bin/bash

# ==============================================================================
# A script for changing ID and group ID of the non-root user. It responds to the
# following environmental variables:
#
#     USER_NAME       (required) username for new linux user
#     USER_ID         (required) ID for new linux user
#     GROUP_ID        (required) Group ID for new linux user
#     USER_PASSWORD   (optional) password for new linux user
#     GRANT_SUDO      (optional) if "TRUE" then user will have sudo privilages
#
# Note: Ideally we would simply run the commands:
#
#     groupmod -o -g $GROUP_ID $USER_NAME
#     usermod -u $USER_ID -g $GROUP_ID $USER_NAME
#     chown -R $USER_NAME:$USER_NAME /home/$USER_NAME
#
# However, problems will occur if ID is large. See for example:
# - https://github.com/moby/moby/issues/5419 (comments about usermod)
# - https://github.com/moby/moby/issues/5419
# - https://github.com/jupyter/docker-stacks/issues/923
# Instead we remove the old user, create a new one, and chown the home directory
# ==============================================================================

# -- exit if $USER variables are not set ---------------------------------------
if [ -z "$USER_NAME" ] || [ -z "$USER_ID" ]  || [ -z "$GROUP_ID" ] ; then
  exit
fi

CUR_ID=$(id -u $USER_NAME)
CUR_GID=$(id -g $USER_NAME)

# -- modify user ---------------------------------------------------------------
if [ "$CUR_ID" != "$USER_ID" ] || [  "$CUR_GID" != "$GROUP_ID" ] ; then
  userdel $USER_NAME && rm -r /var/mail/$USER_NAME
  groupadd -o --gid $GROUP_ID $USER_NAME
  useradd -M --home /home/$USER_NAME -l -o -s /bin/bash --uid $USER_ID --gid $GROUP_ID $USER_NAME
  chown -R $USER_NAME:$USER_NAME /home/$USER_NAME # note: this step will be slow if there are many files in home directory

  # -- Set User Password -------------------------------------------------------
  if [ -n "$USER_PASSWORD" ] ; then
      echo -e "$USER_PASSWORD\n$USER_PASSWORD" | passwd $USER_NAME
  fi

  # -- Grant sudo --------------------------------------------------------------
  # passwordless sudo if PASSWORDLESS is specified, or if TRUE is specified and user password is empty
  if [[ "$GRANT_SUDO" = "PASSWORDLESS" ||  ( "$GRANT_SUDO" = "TRUE" && -z "$USER_PASSWORD" ) ]] ; then    
    usermod -aG wheelnopw $USER_NAME
  elif [ "$GRANT_SUDO" = "TRUE" ] ; then
    usermod -aG wheel $USER_NAME
  fi

fi