var Migrations = artifacts.require("Migrations");

const migrateFunction1 = (deployer) => {
  deployer.deploy(Migrations);
}

module.exports = migrateFunction1;
