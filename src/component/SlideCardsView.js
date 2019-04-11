import PropTypes from 'prop-types';
import React from 'react';
import {requireNativeComponent, StyleSheet} from 'react-native';

class SlideCardsView extends React.Component {
  render() {
    return <RNTSlideCards {...this.props} style={styles.container} />;
  }
}

const styles = StyleSheet.create({
  container: {
      flex: 1,
  }
});

SlideCardsView.propTypes = {
  term: PropTypes.string,
};

var RNTSlideCards = requireNativeComponent('RNTSlideCards', SlideCardsView);

module.exports = SlideCardsView;