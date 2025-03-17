import { BOX_SIZE, COLUMNS, COUNT_ITEMS } from '@/constants/DummyData';
import { useEffect, useState } from 'react';
import { Animated, Dimensions, Easing, Image, Pressable, SafeAreaView, ScrollView, StyleSheet, View } from 'react-native';
import DraggableGrid from 'react-native-draggable-grid';
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

  const renderItem = ({ index }: Item) => {
    return <Animated.View style={{
      ...styles.grid, 
      backgroundColor: backgroundColor(index),
    }} />
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
        <Animated.View>
          <Animated.Text style={{color: 'white', fontWeight: '500'}}>
            {isShow ? 'Hide List' : 'Show List'}
          </Animated.Text>
        </Animated.View>
      </Pressable>
      <View style={styles.imageContainer}>
        <Animated.View style={{transform: [{ rotate: spin }]}}>
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
