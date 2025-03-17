import { BOX_SIZE, COLUMNS, COUNT_ITEMS } from '@/constants/DummyData'
import { useEffect, useState } from 'react'
import { Animated, Dimensions, Easing, Image, SafeAreaView, StyleSheet, View } from 'react-native'
import DraggableGrid from 'react-native-draggable-grid'
import { ScrollView } from 'react-native-gesture-handler'
const bgImage = require('../../../assets/images/rotating-image.jpg')

export type Item = {
  index: number
  key: string
}

const initValues: Item[] = Array.from({ length: COUNT_ITEMS }).map((_, index) => {
  return {
    index,
    key: (index + 1).toString(),
  }
})

export default function IntensiveTasks() {
  const [isScrollEnable, setIsScrollEnable] = useState<boolean>(true)
  const [data, setData] = useState<Item[]>(initValues)
  const [animationValue, _] = useState(new Animated.Value(0))

  const runAnimationFn = () => {
    Animated.loop(
      Animated.timing(animationValue, {
        toValue: 1,
        duration: 1500,
        easing: Easing.linear,
        useNativeDriver: true
      })
    ).start()
  }

  const spin = animationValue.interpolate({
    inputRange: [0, 1],
    outputRange: ["0deg", "360deg"],
  })

  const backgroundColor = (index: number) => animationValue.interpolate({
    inputRange: [0, 1],
    outputRange: index % 2 === 0 ? ['#FF6969', '#6987FF'] : ['#6987FF', '#FF6969']
  });

  const borderColor = (index: number) => animationValue.interpolate({
    inputRange: [0, 1],
    outputRange: index % 2 === 0 ? ['#F50000', '#00F535'] : ['#00F535', '#F50000']
  });

  useEffect(() => {
    runAnimationFn()
  }, [])

  const renderItem = ({ index }: Item) => {
    return <Animated.View style={{
      ...styles.grid, 
      backgroundColor: backgroundColor(index),
      borderColor: borderColor(index),
    }} />
  }
  
  return (
    <SafeAreaView style={styles.container}>
      <View style={styles.imageContainer}>
        <Animated.View style={{transform: [{ rotate: spin }]}}>
          <Image resizeMode='cover' source={bgImage} style={styles.image} />
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
  image: {
    overflow: 'visible',
    width: Dimensions.get('window').width / 2,
    height: Dimensions.get('window').width / 2,
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
