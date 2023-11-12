import { ethers } from 'hardhat';

async function main() {
  try {
    const Contract = await ethers.getContractFactory('ZKNft');

    const contract = await Contract.deploy();
    await contract.deployed();

    console.log(contract.address);
    return;
  } catch (error: any) {
    console.log(error.message);
    return;
  }
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
