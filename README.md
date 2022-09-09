Install

npm install '@truffle/hdwallet-provider' - In case if you get error 'Cannot find module '@truffle/hdwallet-provider''' - run in the project location where you are deploying.

Deploying
truffle deploy --network rinkeby
// In case of error 'Error: Callback was already called'
https://ethereum.stackexchange.com/questions/82759/truffle-deployment-error-while-deploying-with-infura-error-callback-was-alread
truffle deploy --network rinkeby --skipDryRun
