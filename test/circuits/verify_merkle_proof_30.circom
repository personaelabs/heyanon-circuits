pragma circom 2.0.2;

include "../../circuits/merkle.circom";

component main {public [root]} = 
    MerkleTreeChecker(30);