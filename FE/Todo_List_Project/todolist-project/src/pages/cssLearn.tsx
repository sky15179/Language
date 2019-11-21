import React, { Component } from 'react'

class CSSLearn extends Component {

  render() {
    return (
      <div
        style={{
          flexDirection: 'column',
          background: 'gray',
          height: 500,
          display: 'flex',
          justifyContent: 'center',
          flex: 1
        }}>
        <div>
          <div style={{ background: 'red' }}>测试</div>
          <div style={{ background: 'green' }}>测试1</div>
          <div style={{ background: 'yellow' }}>测试2</div>
        </div>
      </div>
    )
  }
}

export default CSSLearn
