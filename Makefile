export WORK_ROOT=`pwd`/../../layers
export INTERFACE_ROOT=${WORK_ROOT}
export JUJU_MODEL_NAME='sge-sandbox'

deploy-clean-model: build
	juju destroy-model ${JUJU_MODEL_NAME} -y
	juju add-model ${JUJU_MODEL_NAME}
	juju deploy ./bundle.yaml

deploy: build
	juju deploy ./bundle.yaml

build:
	( cd ${WORK_ROOT}/charm-layer-sge-master; make build )
	( cd ${WORK_ROOT}/charm-layer-sge-client; make build )

# publish the built charm
publish: republish

republish:
	$(eval published_url := $(shell charm push ./ | grep url | awk {'print $$2'}))
	charm release $(published_url)

