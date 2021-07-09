# Common
# OPERATOR_NAME=nfs-provisioner-operator
OPERATOR_NAME=nfs-provisioner-operator
OPERATOR_CRD_API=nfsprovisioners.cache.jhouse.com
GIT_REPO_HOST=github.com
GIT_REPO_ORG=Jooho
GIT_REPO_BRANCH=master
IMG_REG_HOST=quay.io
IMG_REG_ORG=jooholee
# TEST_NAMESPACE=${OPERATOR_NAME}
TEST_NAMESPACE=redhat-ods-applications

# Manifests 
MANIFESTS_IMG_TAG=latest
OPENSHIFT_USER=
OPENSHIFT_PASS=
OPENSHIFT_LOGIN_PROVIDER=test-htpasswd-provider
TESTS_REGEX=


#---------------------------------------------
# Do NOT CHNAGE
# TEST HARNESS
TEST_HARNESS_NAME=${OPERATOR_NAME}-test-harness
TEST_HARNESS_GIT_REPO_URL=${GIT_REPO_HOST}/${GIT_REPO_ORG}/${TEST_HARNESS_NAME}
TEST_HARNESS_FULL_IMG_URL=${IMG_REG_HOST}/${IMG_REG_ORG}/${TEST_HARNESS_NAME}:${TEST_HARNESS_IMG_TAG:-latest}


# MANIFESTS
MANIFESTS_NAME=${OPERATOR_NAME}-manifests
MANIFESTS_GIT_REPO_URL=${GIT_REPO_HOST}/${GIT_REPO_ORG}/${MANIFESTS_NAME}
MANIFESTS_FULL_IMG_URL=${IMG_REG_HOST}/${IMG_REG_ORG}/${MANIFESTS_NAME}:${MANIFESTS_IMG_TAG}
## Location inside the container where CI system will retrieve files after a test run
ARTIFACT_DIR=/tmp/artifacts
LOCAL_ARTIFACT_DIR="${PWD}/artifacts"

