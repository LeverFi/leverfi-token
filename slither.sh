docker run \
    -e SOLC_VERSION=0.8.5 \
    -v $(pwd)/runSlither.sh:/home/ethsec/runSlither.sh \
    -v $(pwd):/home/ethsec/project \
    -v $(pwd)/lib:/home/ethsec/project/lib \
    trailofbits/eth-security-toolbox \
    /bin/bash -c "solc-select install 0.8.5 && solc-select use 0.8.5 && slither /home/ethsec/project/contracts/Lever2.sol \
    --solc-remaps '@openzeppelin/contracts/=/home/ethsec/project/lib/openzeppelin-contracts/contracts/ @openzeppelin/contracts-upgradeable/=/home/ethsec/project/lib/openzeppelin-contracts-upgradeable/contracts/' \
    --filter-paths 'openzeppelin' \
    --solc-args '--allow-paths /home/ethsec/project/lib'"