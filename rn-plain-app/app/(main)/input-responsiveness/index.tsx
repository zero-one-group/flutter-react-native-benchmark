import ParallaxScrollView from '@/components/ParallaxScrollView';
import { ThemedText } from '@/components/ThemedText';
import { ThemedView } from '@/components/ThemedView';
import { StyleSheet } from 'react-native';

export default function InputResponsiveness() {
  return (
    <ParallaxScrollView headerBackgroundColor={{ light: '#D0D0D0', dark: '#D0D0D0' }}>
      <ThemedView style={styles.titleContainer}>
        <ThemedText type='subtitle'>Input Responsiveness</ThemedText>
      </ThemedView>
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
});
