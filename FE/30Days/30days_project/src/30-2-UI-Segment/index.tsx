import React, { Component } from 'react'
import './index.css';

export default class Segment extends Component {
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
          img: 'https://img.wanyx.com/softImg/soft/1650_s.jpg'
        },
        {
          title: '数据二',
          subtitle: '标题二',
          img: 'http://p0.meituan.net/movie/bb9f75599bfbb2c4cf77ad9abae1b95c1376927.jpg'
        },
        {
          title: '数据三',
          subtitle: '标题三',
          img: 'http://p0.meituan.net/movie/bb9f75599bfbb2c4cf77ad9abae1b95c1376927.jpg'
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
    return <img src={icon} className="itemContainer-image" />
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
        <div>{!!icon ? this.createIcon(icon) : null}</div>
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
