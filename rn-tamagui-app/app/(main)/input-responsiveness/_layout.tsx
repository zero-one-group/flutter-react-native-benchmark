import { Stack } from "expo-router";
import { GestureHandlerRootView } from "react-native-gesture-handler";
import { SafeAreaProvider } from "react-native-safe-area-context";

const RootLayout = () => {
  return (
    <GestureHandlerRootView>
      <SafeAreaProvider>
        <Stack>
          <Stack.Screen
            name="index"
            options={{
              headerShown: false
            }}
          />
        </Stack>
      </SafeAreaProvider>
    </GestureHandlerRootView>
  );
};

export default RootLayout;