#!/usr/bin/python

import os
import sys

SITENAME = os.environ.get("BEPASTY_SITENAME", None)
SECRET_KEY = os.environ.get("BEPASTY_SECRET_KEY", None)
APP_BASE_PATH = os.environ.get("BEPASTY_APP_BASE_PATH", None)

STORAGE_FILESYSTEM_DIRECTORY = os.environ.get(
  "BEPASTY_STORAGE_FILESYSTEM_DIRECTORY", "/data",
)

DEFAULT_PERMISSIONS = os.environ.get("BEPASTY_DEFAULT_PERMISSIONS", "create,read")

PERMISSIONS = {}
admin_secret = os.environ.get("BEPASTY_ADMIN_SECRET", None)
if admin_secret is not None:
  PERMISSIONS.update({admin_secret: "admin,list,create,modify,read,delete"})
other_permissions = os.environ.get("BEPASTY_PERMISSIONS", None)
if other_permissions is not None:
  for permission in other_permissions.split("|"):
    permission_secret = permission.strip().split(":")[0].strip()
    permission = permission.strip().split(":")[1].strip()
    PERMISSIONS.update({permission_secret: permission})

try:
  max_allowed_file_size = os.environ.get("BEPASTY_MAX_ALLOWED_FILE_SIZE", 5000000000)
  MAX_ALLOWED_FILE_SIZE = int(max_allowed_file_size)
except ValueError as err:
  print("\n\nInvalid BEPASTY_MAX_ALLOWED_FILE_SIZE: %s", str(err))
  sys.exit(1)

SESSION_COOKIE_SECURE = os.environ.get("BEPASTY_SESSION_COOKIE_SECURE", 'True') != 'False'

try:
  max_body_size = os.environ.get("BEPASTY_MAX_BODY_SIZE", 1040384)
  MAX_BODY_SIZE = int(max_body_size)
except ValueError as err:
  print("\n\nInvalid BEPASTY_MAX_BODY_SIZE: %s", str(err))
  sys.exit(1)

ASCIINEMA_THEME = os.environ.get("BEPASTY_ASCIINEMA_THEME", "asciinema")
