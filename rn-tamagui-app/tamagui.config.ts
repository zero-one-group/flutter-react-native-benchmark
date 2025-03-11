import { defaultConfig } from "@tamagui/config/v4";
import * as tamagui from "tamagui";

const tamaguiConfig = tamagui.createTamagui(defaultConfig);

type Conf = typeof tamaguiConfig;
declare module "tamagui" {
  interface TamaguiCustomConfig extends Conf {}
}
export default tamaguiConfig;
