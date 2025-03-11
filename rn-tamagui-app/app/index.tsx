import React from "react";
import { SafeAreaView } from "react-native-safe-area-context";
import { Button, Image, Text, XStack, YStack } from "tamagui";
import { Words } from "@/constants/Words";

const index = () => {
  return (
    <SafeAreaView>
      <YStack>
        <XStack justify={"center"} items={"center"}>
          <Image
            source={require("@/assets/images/zog-logo.png")}
            width={"$10"}
            height={"$10"}
          ></Image>
          <Text>{Words.performanceTest}</Text>
        </XStack>
        <Button marginInline={30}>{Words.resIntensiveTask}</Button>
      </YStack>
    </SafeAreaView>
  );
};

export default index;
