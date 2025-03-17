import React from "react";
import { SafeAreaView } from "react-native-safe-area-context";
import { Image, SizableText, Spacer, XStack, YStack } from "tamagui";
import { Words } from "@/constants/Words";
import { Href, router } from "expo-router";
import { StyleSheet } from "react-native";
type Path = "/ui-performance" | "/intensive-tasks" | "/input-responsiveness";

type Content = {
  label: string;
  color: string;
  route: Path;
};

const index = () => {
  const contentList: Content[] = [
    {
      label: Words.uiPerformance,
      color: "#CFE9FF",
      route: "/ui-performance",
    },
    {
      label: Words.resIntensiveTask,
      color: "#CFFFF5",
      route: "/intensive-tasks",
    },
    {
      label: Words.inputResponsiveness,
      color: "#FFEDCF",
      route: "/input-responsiveness",
    },
  ];

  return (
    <SafeAreaView>
      <YStack style={style.screenContainer}>
        <XStack justify={"center"} items={"center"}>
          <Image
            source={require("@/assets/images/zog-logo.png")}
            style={{ width: 42, height: 37 }}
          ></Image>
          <Spacer width={14} />
          <SizableText size="$8" fontWeight="bold">
            {Words.performanceTest}
          </SizableText>
        </XStack>
        {contentList.map((content, index) => (
          <YStack
            key={index}
            onPress={() => router.push(content.route as Href)}
            style={{ ...style.cardContainer, backgroundColor: content.color }}
            height={"$10"}
          >
            <SizableText size="$4" fontWeight="bold">
              {content.label}
            </SizableText>
          </YStack>
        ))}
      </YStack>
    </SafeAreaView>
  );
};

export default index;

const style = StyleSheet.create({
  screenContainer: {
    padding: 16,
    gap: 16,
  },
  cardContainer: {
    alignItems: "center",
    justifyContent: "center",
    borderRadius: 16,
  },
});
