#!/bin/bash

source $TEST_DIR/common

MY_DIR=$(readlink -f `dirname "${BASH_SOURCE[0]}"`)

source ${MY_DIR}/../util
source ${TEST_DIR}/../env.sh

JH_LOGIN_USER=${OPENSHIFT_USER:-"admin"} #Username used to login to JH
JH_LOGIN_PASS=${OPENSHIFT_PASS:-"admin"} #Password used to login to JH
OPENSHIFT_LOGIN_PROVIDER=${OPENSHIFT_LOGIN_PROVIDER:-"test-htpasswd-provider"} #OpenShift OAuth provider used for login
JH_AS_ADMIN=${JH_AS_ADMIN:-"true"} #Expect the user to be Admin in JupyterHub
ODS_CI_REPO_ROOT=${ODS_CI_REPO_ROOT:-"${HOME}/src/ods-ci"}

os::test::junit::declare_suite_start "$MY_SCRIPT"

function test_operator() {
    header "Testing ISV Operator installation"
    os::cmd::expect_success "oc project ${TEST_NAMESPACE}"
    os::cmd::try_until_text "oc get deploymentconfig jupyterhub -n ${TEST_NAMESPACE}" "jupyterhub" $defaulttimeout $defaultinterval
    os::cmd::try_until_text "oc get pods -l deploymentconfig=jupyterhub --field-selector='status.phase=Running' -o jsonpath='{$.items[*].metadata.name}' -n ${TEST_NAMESPACE}" "jupyterhub" $defaulttimeout $defaultinterval
    runningpods=($(oc get pods -l deploymentconfig=jupyterhub --field-selector="status.phase=Running" -o jsonpath="{$.items[*].metadata.name}"))
    os::cmd::expect_success_and_text "echo ${#runningpods[@]}" "1"
}

function test_ods_ci() {
    header "Running Integration Test(Jupyterhub using ODS-CI automation)"

    os::cmd::expect_success "oc project redhat-ods-applications"
    ODH_JUPYTERHUB_URL="https://"$(oc get route jupyterhub -o jsonpath='{.spec.host}')
    pushd ${HOME}/src/ods-ci
    #TODO: Add a test that will iterate over all of the notebook using the notebooks in https://github.com/opendatahub-io/testing-notebooks
    os::cmd::expect_success "run_robot_test.sh --test-artifact-dir ${ARTIFACT_DIR} --test-case ${MY_DIR}/../resources/ods-ci/test-odh-jupyterlab-git-notebook.robot --test-variables-file ${MY_DIR}/../resources/ods-ci/test-variables.yml --test-variable 'ODH_JUPYTERHUB_URL:${ODH_JUPYTERHUB_URL}' --test-variable RESOURCE_PATH:${PWD}/tests/Resources"
    popd
}

test_operator
test_ods_ci

os::test::junit::declare_suite_end
