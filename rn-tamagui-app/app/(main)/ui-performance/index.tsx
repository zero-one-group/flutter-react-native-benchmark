import { data } from '@/constants/DummyData';
import React from 'react';
import { FlatList, StyleSheet } from 'react-native';
import { SafeAreaProvider, SafeAreaView } from 'react-native-safe-area-context';
import { SizableText } from 'tamagui';

export default function UiPerformance() {
    return (
        <SafeAreaProvider>
            <SafeAreaView style={styles.container}>
                <FlatList
                    data={data}
                    renderItem={({ item }) => <SizableText style={styles.item}>{item.name}</SizableText>}
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
