import { useEffect, useState } from 'react';
import { Animated, Dimensions, Easing, FlatList, Image, Pressable, SafeAreaView, StyleSheet, View } from 'react-native';
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

const renderItem = () => {
  return <Animated.View style={{
    ...styles.grid, 
    backgroundColor: generateBgColor(),
  }} />
}

export default function InputResponsiveness() {
  const [isShow, setIsShow] = useState<boolean>(true);
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
        <Pressable
          style={{...styles.switch, backgroundColor: isShow ? 'red' : 'blue'}}
          onPress={() => {
            setIsShow(prev => !prev)
          }}
        >
          <Animated.View>
            <Animated.Text style={{color: 'white', fontWeight: '500'}}>
              {isShow ? 'Hide List' : 'Show List'}
            </Animated.Text>
          </Animated.View>
        </Pressable>
        <View style={styles.imageContainer}>
          <Animated.View style={{transform: [{ rotate: spin }]}}>
            <Image source={bgImage} />
          </Animated.View>
        </View>
        {isShow && <FlatList
          data={Array.from({ length: COUNT_ITEMS })}
          numColumns={COLUMNS}
          style={styles.gridContainer}
          renderItem={renderItem}
        />}
      </SafeAreaView>
    </SafeAreaProvider>
  );
}

const styles = StyleSheet.create({
  container: {
    minHeight: Dimensions.get('window').height,
    paddingInline: 20,
    flexDirection: 'column',
    gap: 3,
  },
  imageContainer: {
    position: 'absolute',
    left: '50%',
    right: '50%',
    height: Dimensions.get('window').height / 1.5,
    justifyContent: 'center',
    alignItems: 'center',
  },
  switch: {
    alignSelf: 'center',
    alignItems: 'center',
    justifyContent: 'center',
    borderRadius: 15,
    paddingInline: 20,
    paddingBlock: 10,
    marginBlock: 10
  },
  image: {
    flex: 1,
    justifyContent: 'center',
  },
  gridContainer: {
    flex: 1,
    marginBottom: 100
  },
  grid: {
    borderRadius: 15,
    alignItems: 'center',
    justifyContent: 'center',
    flex: 1,
    margin: 3,
    height: Dimensions.get('window').width / COLUMNS,
    shadowColor: 'black',
    shadowOffset: { width: 1, height: 1 },
    shadowOpacity: 0.3,
    shadowRadius: 20,  
    elevation: 3
  }
});
