import { BOX_SIZE, COLUMNS, COUNT_ITEMS } from '@/constants/DummyData'
import { useEffect, useState } from 'react'
import { Dimensions, Image, SafeAreaView, StyleSheet, View } from 'react-native'
import Animated, { useSharedValue, useAnimatedStyle, withRepeat, withTiming, Easing, interpolateColor } from 'react-native-reanimated'
import DraggableGrid from 'react-native-draggable-grid'
import { ScrollView } from 'react-native-gesture-handler'

const bgImage = require('../../../assets/images/rotating-image.jpg')

export type Item = {
  index: number
  key: string
  id: string
}

const initValues: Item[] = Array.from({ length: COUNT_ITEMS }).map((_, index) => {
  return {
    index,
    key: (index + 1).toString(),
    id: (index + 1).toString(),
  }
})

export default function IntensiveTasksReanimated() {
  const [isScrollEnable, setIsScrollEnable] = useState<boolean>(true)
  const [data, setData] = useState<Item[]>(initValues)
  const rotation = useSharedValue(0)
  const colorChanges = useSharedValue(0)

  const runAnimationFn = () => {
    rotation.value = withRepeat(
      withTiming(360, { duration: 1500, easing: Easing.linear }),
      -1,
      false
    )
    colorChanges.value = withRepeat(withTiming(1, { duration: 1500 }), -1, true)
  }

  const spin = useAnimatedStyle(() => ({
    transform: [{ rotate: `${rotation.value}deg` }]
  }))

  useEffect(() => {
    runAnimationFn()
  }, [])

  const backgroundColor1 = useAnimatedStyle(() => {
    return {
      backgroundColor: interpolateColor(
        colorChanges.value,
        [0, 1],
        ['#FF6969', '#6987FF']
      )
    }
  })

  const backgroundColor2 = useAnimatedStyle(() => {
    return {
      backgroundColor: interpolateColor(
        colorChanges.value,
        [0, 1],
        ['#6987FF', '#FF6969']
      )
    }
  })

  const borderColor1 = useAnimatedStyle(() => {
    return {
      borderColor: interpolateColor(
        rotation.value,
        [0, 1],
        ['#F50000', '#00F535']
      )
    }
  })

  const borderColor2 = useAnimatedStyle(() => {
    return {
      borderColor: interpolateColor(
        rotation.value,
        [0, 1],
        ['#00F535', '#F50000']
      )
    }
  })

  const renderItem = ({ index }: Item) => {
    return <Animated.View style={[
      styles.grid,
      index % 2 === 0 ? backgroundColor1 : backgroundColor2,
      index % 2 === 0 ? borderColor1 : borderColor2,
    ]} />
  }
  
  return (
    <SafeAreaView style={styles.container}>
      <View style={styles.imageContainer}>
        <Animated.View style={spin}>
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
