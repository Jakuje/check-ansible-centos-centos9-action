#! /usr/bin/env bash

set -Eeuo pipefail
set -x

# Generates client.
# env:
#   [required] TARGETS : Path to your ansible role you want to be tested. (e.g, './' or 'roles/my_role/') to be tested
ansible::test() {
  : "${TARGETS?No targets to check. Nothing to do.}"
  : "${GITHUB_WORKSPACE?GITHUB_WORKSPACE has to be set. Did you use the actions/checkout action?}"
  pushd ${GITHUB_WORKSPACE}

  # generate playbook to be executed
  echo -e """---
  - name: test a ansible role
    hosts: localhost
    tags: default
    roles: "${TARGETS}"
    """ | tee -a deploy.yml

  # execute playbook
  ansible-playbook -vvv -i localhost deploy.yml
}

if [ "$0" = "$BASH_SOURCE" ] ; then
  >&2 echo -E "\nRunning Ansible debian check...\n"
  ansible::test
fi