#!/bin/bash
#
# [Author] Jacob Janco (jjanco.dev at gmail dot com)
# Manage symlinks for personal dotfiles

usage() {
cat <<EOF
  Usage: $0 [options]
  -t    <bootstrap_task>    (slink|prune|clean)
  -h    <home_directory>    ($HOME)
EOF
}

# wipe symlinks created by this script
clean() {
  if [ "$#" -ne 2 ]; then
    echo "Need arg1=<home_dir> arg2=<dotfiles_wd>"
    exit 1
  fi
  local home_dir="$1"
  local dotfiles_wd="$2"

  for ent in "$dotfiles_wd"/dotfiles/.*[:alnum:]*; do
    ent_bn=$(basename $ent)
    if [ -d "$ent" ]; then
      if [ -d "$home_dir/$ent_bn" ]; then
        \rm -ir "$home_dir/$ent_bn"
      fi
    elif [ -f "$ent" ]; then
      if [ -f "$home_dir/$ent_bn" ]; then
        \rm -i "$home_dir/$ent_bn"
      fi
    else
      echo "$ent is not a file or directory"
      exit 1
    fi
  done
}

# prune dead symlinks in home directory
prune() {
  if [ "$#" -ne 1 ]; then
    echo "Need arg1=<home_dir>"
    exit 1
  fi
  local home_dir="$1"
  local dotfiles_wd="$2"

  (cd "$home_dir" && \
    find -L . -name . \
    -o -type d -prune -o -type l -exec rm {} +)
}

# symlink ./dotfiles to home directory
slink() {
  if [ "$#" -ne 2 ]; then
    echo "Need arg1=<home_dir> arg2=<dotfiles_wd>"
    exit 1
  fi
  local home_dir="$1"
  local dotfiles_wd="$2"

  prune "$home_dir"
  clean "$home_dir" "$dotfiles_wd"

  for ent in "$dotfiles_wd"/dotfiles/.*[:alnum:]*; do
    ent_bn=$(basename $ent)
    ln -s "$dotfiles_wd/dotfiles/$ent_bn" "$home_dir/$ent_bn"
  done
}

main() {
  local dotfiles_wd="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

  local OPTIND
  while getopts "t:h:" opt; do
    case "$opt" in
      t)
        task="$OPTARG"
        ;;
      h)
        home_dir="$OPTARG"
        ;;
      \?)
        echo "Invalid option: -$OPTARG" >&2
        usage
        exit 1
        ;;
    esac
  done

  if [ -z "$task" ] || [ -z "$home_dir" ]; then
    usage
    exit 1
  fi

  case "$task" in
    slink)
      slink "$home_dir" "$dotfiles_wd"
      ;;
    clean)
      clean "$home_dir" "$dotfiles_wd"
      ;;
    prune)
      prune "$home_dir"
      ;;
    \?)
      echo "Invalid task $task" >&2
      usage
      exit 1
      ;;
  esac
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  main "$@"
fi
