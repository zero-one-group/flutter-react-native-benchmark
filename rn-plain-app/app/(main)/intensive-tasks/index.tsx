import { BOX_SIZE, COLUMNS, COUNT_ITEMS, MAX, MIN } from '@/constants/DummyData'
import { useEffect, useState } from 'react'
import { Animated, Easing, Image, SafeAreaView, StyleSheet, View } from 'react-native'
import DraggableGrid from 'react-native-draggable-grid'
import { ScrollView } from 'react-native-gesture-handler'
const bgImage = require('../../../assets/images/bg.png')

export type Item = {
  key: string
  backgroundColor: string
  borderColor: string
}

const getRandomNumber = () => {
  return Math.floor(Math.random() * (MAX - MIN + 1) + MIN)
}

const generateBgColor = () => {
  const random = getRandomNumber()
  return random === 1 ? '#FF6969' : '#6987FF'
}

const generateBorderColor = () => {
  const random = getRandomNumber()
  return random === 1 ? '#F50000' : '#00F535'
}

const initValues: Item[] = Array.from({ length: COUNT_ITEMS }).map((_, index) => {
  return {
    key: (index + 1).toString(),
    backgroundColor: generateBgColor(),
    borderColor: generateBorderColor()
  }
})

export default function IntensiveTasks() {
  const [isScrollEnable, setIsScrollEnable] = useState<boolean>(true)
  const [data, setData] = useState<Item[]>(initValues)
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

  const renderItem = ({ backgroundColor, borderColor }: Item) => {
    return <Animated.View style={{
      ...styles.grid, 
      backgroundColor,
      borderColor,
    }} />
  }
  
  return (
    <SafeAreaView style={styles.container}>
      <View style={styles.imageContainer}>
        <Animated.View
          style={{transform: [{ rotate: spin }]}}
        >
          <Image source={bgImage} />
        </Animated.View>
      </View>
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
    </SafeAreaView>
  )
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
    borderWidth: 2,
    borderRadius: 8,
    justifyContent: 'center',
    alignItems: 'center',
  }
})
