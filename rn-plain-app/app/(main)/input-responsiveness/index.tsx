import { BOX_SIZE, COLUMNS, COUNT_ITEMS } from '@/constants/DummyData';
import { useEffect, useState } from 'react';
import { Dimensions, Image, Pressable, SafeAreaView, StyleSheet, View } from 'react-native';
import Animated, { useSharedValue, useAnimatedStyle, withRepeat, withTiming, Easing, interpolateColor } from 'react-native-reanimated';
import DraggableGrid from 'react-native-draggable-grid';
import { ScrollView } from 'react-native-gesture-handler';
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

export default function InputResponsiveness() {
  const [isScrollEnable, setIsScrollEnable] = useState<boolean>(true)
  const [data, setData] = useState<Item[]>(initValues)
  const [isShow, setIsShow] = useState<boolean>(true);
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

  const renderItem = ({ index }: Item) => {
    return <Animated.View style={[
      styles.grid,
      index % 2 === 0 ? backgroundColor1 : backgroundColor2,
    ]} />
  }

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
        <View>
          <Animated.Text style={{color: 'white', fontWeight: '500'}}>
            {isShow ? 'Hide List' : 'Show List'}
          </Animated.Text>
        </View>
      </Pressable>
      <View style={styles.imageContainer}>
        <Animated.View style={spin}>
          <Image resizeMode='cover' source={bgImage} style={styles.image} />
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
