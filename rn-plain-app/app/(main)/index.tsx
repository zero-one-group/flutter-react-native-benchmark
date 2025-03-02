import ParallaxScrollView from '@/components/ParallaxScrollView';
import { ThemedText } from '@/components/ThemedText';
import { ThemedView } from '@/components/ThemedView';
import { Href, router } from 'expo-router';
import { StyleSheet, Image, Pressable } from 'react-native';
import Animated from 'react-native-reanimated';

type Path = '/ui-performance' | '/intensive-tasks' | '/input-responsiveness'

type Content = {
  label: string,
  color: string,
  route: Path,
}

export default function Home() {
  const contentList: Content[] = [
    {
      label: 'UI PERFORMANCE',
      color: '#CFE9FF',
      route: '/ui-performance'
    },
    {
      label: 'RES: INTENSIVE TASKS',
      color: '#CFFFF5',
      route: '/intensive-tasks'
    },
    {
      label: 'INPUT RESPONSIVENESS',
      color: '#FFEDCF',
      route: '/input-responsiveness'
    },
  ]

  return (
    <ParallaxScrollView headerBackgroundColor={{ light: '#D0D0D0', dark: '#D0D0D0' }}>
      <ThemedView style={styles.titleContainer}>
        <Animated.View>
          <Image
            source={require('@/assets/images/zog-logo.png')}
            style={styles.logo}
          />
        </Animated.View>
        <ThemedText type='subtitle'>Performance Test</ThemedText>
      </ThemedView>
      {contentList.map((item) => (
        <Pressable key={item.route} onPress={() => router.push(item.route as Href)}>
          <Animated.View style={{...styles.cardContainer, backgroundColor: item.color}}>
            <ThemedText style={styles.label}>{item.label}</ThemedText>
          </Animated.View>
        </Pressable>
      ))}
    </ParallaxScrollView>
  );
}

const styles = StyleSheet.create({
  titleContainer: {
    flexDirection: 'row',
    gap: 3,
    alignItems: 'center',
    justifyContent: 'center'
  },
  logo: {
    height: 80,
    width: 80,
  },
  cardContainer: {
    backgroundColor: '#CFE9FF',
    minHeight: 100,
    borderRadius: 10,
    alignItems: 'center',
    justifyContent: 'center',
  },
  label: {
    fontWeight: 'bold',
  }
});
