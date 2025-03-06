import { BOX_SIZE, COLUMNS, COUNT_ITEMS, MAX, MIN } from '@/constants/DummyData';
import { useEffect, useState } from 'react';
import { Animated, Easing, Image, Pressable, SafeAreaView, ScrollView, StyleSheet, View } from 'react-native';
import DraggableGrid from 'react-native-draggable-grid';
const bgImage = require('../../../assets/images/bg.png')

export type Item = {
  key: string
  backgroundColor: string
}

const getRandomNumber = () => {
  return Math.floor(Math.random() * (MAX - MIN + 1) + MIN);
}

const generateBgColor = () => {
  const random = getRandomNumber()
  return random === 1 ? '#FF6969' : '#6987FF'
}

const renderItem = ({ backgroundColor }: Item) => {
  return <Animated.View style={{
    ...styles.grid, 
    backgroundColor,
  }} />
}

const initValues: Item[] = Array.from({ length: COUNT_ITEMS }).map((_, index) => {
  return {
    key: (index + 1).toString(),
    backgroundColor: generateBgColor(),
  }
})

export default function InputResponsiveness() {
  const [isScrollEnable, setIsScrollEnable] = useState<boolean>(true)
  const [data, setData] = useState<Item[]>(initValues)
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
      {isShow &&
        <ScrollView scrollEnabled={isScrollEnable}>
          <DraggableGrid
            style={styles.gridContainer}
            numColumns={COLUMNS}
            renderItem={renderItem}
            data={data}
            onDragItemActive={() => setIsScrollEnable(false)}
            onDragRelease={(data) => {
              setData(data)
              setIsScrollEnable(true)
            }}
          />
        </ScrollView>
      }
    </SafeAreaView>
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
  },
  grid: {
    width: BOX_SIZE - 10,
    height: BOX_SIZE - 10,
    borderRadius: 8,
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
});
