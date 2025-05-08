import { Stack } from "expo-router";

const RootLayout = () => {
  return (
    <Stack>
      <Stack.Screen
        name="index"
        options={{
          headerShown: false
        }}
      />
      <Stack.Screen
        name="ui-performance"
        options={{
          headerTitle: "Performance Test",
        }}
      />
      <Stack.Screen
        name="intensive-tasks"
        options={{
          headerTitle: "Intensive Tasks",
        }}
      />
      <Stack.Screen
        name="intensive-tasks-reanimated"
        options={{
          headerTitle: "Intensive Tasks (Reanimated)",
        }}
      />
      <Stack.Screen
        name="input-responsiveness"
        options={{
          headerTitle: "Input Responsiveness",
        }}
      />
    </Stack>
  );
};

export default RootLayout;