import React, { Component } from 'react'
import logo from '.././logo.svg'
// import './style.less'
import './index.css';

export default class List extends Component {
    constructor(props: any) {
        super(props)
    }

    componentWillMount() {

    }

    componentDidMount() {

    }
    
    createItems = (array: ListItemProps[]) => {
        
    }

    render() {
      const datas = [
        {
          title: '数据一',
          subtitle: '标题一',
          img: 'https://raw.githubusercontent.com/sky15179/Images/master/20190916170919.png'
        }
      ]
        return (
          <div style={ { flex: 1} }>
            测试
            <ul className="item-title">
              111
            </ul>
            <ul>111</ul>
            <ListItem title="测试2" subtitle="测试副标题" ></ListItem>
          </div>
        )
    }
}

class ListHeader extends Component {

}

class ListFooter extends Component {

}

interface ListItemProps {
    icon?: string
    title?: string
    subtitle?: string
}

interface ButtonProps {
  title: string
  onClick: () => void
}

class Button extends Component<ButtonProps> {
  onFocus = false

  render () {
        return (
          <div
            onClick={event => {
              this.props.onClick()
            }}
            onFocus={e => {
              this.onFocus = true
            }}
            onBlur={e => {
              this.onFocus = false
            }}
            className={this.onFocus ? 'itemButtonFocus' : 'itemButton'}>
            {this.props.title}
          </div>
        )
  }
}

class ListItem extends Component<ListItemProps> {
  createIcon = (icon: string) => {
    return (
        <img src={logo} className="itemContainer-image" alt="logo" />
    )
  }

  createTitle = (title: string) => {
    return <div className="itemContainer-title">{title}</div>
  }

  createSubTitle = (title: string) => {
    return <div className="itemContainer-subtitle">{title}</div>
  }

  render() {
    let { icon, title, subtitle } = this.props
    return (
      <div className="itemContainer">
        <div>{this.createIcon('123')}</div>
        <div className="itemTitleContainer">
          {!!title ? this.createTitle(title) : null}
          {!!subtitle ? this.createSubTitle(subtitle) : null}
        </div>
        <Button
          title="添加"
          onClick={() => {
            alert('点击')
          }}></Button>
      </div>
    )
  }
}
