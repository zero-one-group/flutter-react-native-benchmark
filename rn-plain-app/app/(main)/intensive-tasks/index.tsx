import { useEffect, useState } from 'react';
import { Animated, Dimensions, Easing, FlatList, Image, SafeAreaView, StyleSheet, View } from 'react-native';
import { SafeAreaProvider } from 'react-native-safe-area-context';
const bgImage = require('../../../assets/images/bg.png')

const COLUMNS = 3
const MIN = 0
const MAX = 1
const COUNT_ITEMS = 99

const getRandomNumber = () => {
  return Math.floor(Math.random() * (MAX - MIN + 1) + MIN);
}

const generateBgColor = () => {
  const random = getRandomNumber()
  return random === 1 ? '#FF6969' : '#6987FF'
}

const generateBorderColor = () => {
  const random = getRandomNumber()
  return random === 1 ? '#F50000' : '#00F535'
}

const renderItem = () => {
  return <Animated.View style={{
    ...styles.grid, 
    backgroundColor: generateBgColor(),
    borderColor: generateBorderColor(),
  }} />
}

export default function IntensiveTasks() {
  const [spinValue, _] = useState(new Animated.Value(0))

  const runAnimationFn = () => {
    Animated.loop(
      Animated.timing(spinValue, {
        toValue: 1,
        duration: 1500,
        easing: Easing.linear,
        useNativeDriver: true
      })
    ).start()
  }

  const spin = spinValue.interpolate({
    inputRange: [0, 1],
    outputRange: ["0deg", "360deg"],
  })

  useEffect(() => {
    runAnimationFn()
  }, [])
  
  return (
    <SafeAreaProvider>
      <SafeAreaView style={styles.container}>
        <View style={styles.imageContainer}>
          <Animated.View
            style={{transform: [{ rotate: spin }]}}
          >
            <Image source={bgImage} />
          </Animated.View>
        </View>
        <FlatList
          data={Array.from({ length: COUNT_ITEMS })}
          numColumns={COLUMNS}
          style={styles.gridContainer}
          renderItem={renderItem}
        />
      </SafeAreaView>
    </SafeAreaProvider>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1
  },
  imageContainer: {
    alignSelf: 'center',
    position: 'absolute',
    top: '30%'
  },
  gridContainer: {
    flex: 1,
    paddingInline: 10,
  },
  grid: {
    borderRadius: 15,
    borderWidth: 2,
    alignItems: 'center',
    justifyContent: 'center',
    flex: 1,
    margin: 3,
    height: Dimensions.get('window').width / COLUMNS,
    shadowColor: 'black',
    shadowOffset: { width: 0, height: 1 },
    shadowOpacity: 0.5,
    shadowRadius: 2,  
    elevation: 5
  }
});
