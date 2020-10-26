#!/bin/bash

# Env config
export KUBECONFIG=/config/kubeconfig
export DOCKER_CONFIG=/config/

# Download latest descriptor
dldescriptor() {
	(pivnet --config /config/pivnetconfig download-product-files -p tbs-dependencies -r $(pivnet --config /config/pivnetconfig releases -p tbs-dependencies --format=json | jq .[0].version -r) -i $(pivnet --config /config/pivnetconfig product-files -p tbs-dependencies -r $(pivnet --config /config/pivnetconfig releases -p tbs-dependencies --format=json | jq .[0].version -r) --format json | jq '.[] | select(.name | contains("descriptor"))' | jq .id) -d /tmp/ > /dev/null)
	local dlcode=$?
	return $dlcode
}

if dldescriptor; then
	imagetypes=(tiny base full)
	descriptorpath=$(ls /tmp/descriptor*.yaml)
	mapfile -t descriptorcontents < <( cat $descriptorpath | yq r - --collect stacks.*.buildImage.image -j | jq .[] -r )

	for i in ${imagetypes[@]}; do
		x=$(for z in ${descriptorcontents[@]}; do if [[ $z =~ $i ]]; then echo $z && exit; fi; done)
		if [[ $x =~ $i ]]; then
			ihash=$(echo $x | sed 's/^.*sha256://')
			kphash=$(kp clusterstack status $i | grep Build | awk '{print $3}' | sed 's/^.*sha256://')
			if [[ $ihash != $kphash ]]; then
				echo "update required to $i image - updating all images and exiting"
				kp import -f $descriptorpath
				exit
			else
				echo "no update required to $i image!"
			fi
		else
			echo "something went wrong!"
		fi
	done
else
	echo "download of descriptor failed"
	return 1
fi