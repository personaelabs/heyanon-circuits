# dizkus-circuits

diZKus standard circuit

## Setup

(from https://github.com/0xPARC/cabal/blob/main/circuits/README.md)

After you clone the repo, from the root of the repo run:
```
git submodule update --init
```

Follow the intructions here to get circom2 (the ZKSnark compiler) installed in your system
https://docs.circom.io/getting-started/installation/

You should probably also install VSCode extension to work with circom.

To install dependencies.
```
yarn
cd circom-ecdsa
yarn
```

Download a Powers of Tau file with `2^21` constraints and copy it into the
`circuits` subdirectory of the project, with the name `pot21_final.ptau`. We do not provide such a file in this repo due to its large size. You can download and copy Powers of Tau files from the Hermez trusted setup from [this repository](https://github.com/iden3/snarkjs#7-prepare-phase-2).