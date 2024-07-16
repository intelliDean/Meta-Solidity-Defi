import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const DeployModule = buildModule("DeployModule", (m) => {
  const defiScheme = m.contract("DeFiScheme");

  const insuranceFactory = m.contract("InsuranceFactory", [defiScheme]);

  return { defiScheme, insuranceFactory };
});

export default DeployModule;