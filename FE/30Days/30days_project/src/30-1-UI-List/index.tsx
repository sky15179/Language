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
        },
        {
          title: '数据二',
          subtitle: '标题二',
          img: 'https://raw.githubusercontent.com/sky15179/Images/master/20190916170919.png'
        },
        {
          title: '数据三',
          subtitle: '标题三',
          img: 'https://raw.githubusercontent.com/sky15179/Images/master/20190916170919.png'
        }
      ]
      const items = datas.map((e, index) => {
        return <ListItem title={e.title} subtitle={e.subtitle} icon={e.img}></ListItem>
      })
        return <div style={{ flex: 1 }}>{items}</div>
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

class Button extends Component<ButtonProps, { onFocus:boolean }> {
  constructor(props: any) {
    super(props)
    this.state = {
      onFocus: false
    }
  }

  render() {
    return (
      <div
        onClick={event => {
          this.props.onClick()
        }}
        onMouseOver={e => {
          this.setState({ onFocus: true })
        }}
        onMouseOut={e => {
          this.setState({ onFocus: false })
        }}
        className={this.state.onFocus ? 'itemButtonFocus' : 'itemButton'}>
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
