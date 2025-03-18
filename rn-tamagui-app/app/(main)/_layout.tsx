import { Words } from "@/constants/Words";
import { Stack } from "expo-router";

const RootLayout = () => {
  return (
    <Stack>
      <Stack.Screen
        name="index"
        options={{
          headerShown: false,
        }}
      />
      <Stack.Screen
        name="ui-performance"
        options={{
          headerTitle: Words.uiPerformance,
        }}
      />
      <Stack.Screen
        name="intensive-tasks"
        options={{
          headerTitle: Words.resIntensiveTask,
        }}
      />
      <Stack.Screen
        name="input-responsiveness"
        options={{
          headerTitle: Words.inputResponsiveness,
        }}
      />
    </Stack>
  );
};

export default RootLayout;
