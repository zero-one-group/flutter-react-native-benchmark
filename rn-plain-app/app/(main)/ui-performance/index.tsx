import ParallaxScrollView from '@/components/ParallaxScrollView';
import { ThemedText } from '@/components/ThemedText';
import { ThemedView } from '@/components/ThemedView';
import { data } from '@/constants/DummyData';
import React from 'react';
import { FlatList, StyleSheet } from 'react-native';
import { SafeAreaProvider, SafeAreaView } from 'react-native-safe-area-context';

export default function UiPerformance() {
  return (
    <SafeAreaProvider>
      <SafeAreaView style={styles.container}>
        <FlatList
          data={data}
          renderItem={({item}) => <ThemedText style={styles.item}>{item.name}</ThemedText>}
          keyExtractor={(item) => item.id.toString()}
        />
      </SafeAreaView>
    </SafeAreaProvider>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#FFFFFF'
  },
  item: {
    padding: 20,
    marginVertical: 1,
    borderBottomWidth: 0.2,
    borderBottomColor: '#E5E5E5'
  }
});
