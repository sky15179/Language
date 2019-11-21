import React, { Component } from 'react'
import logo from '.././logo.svg'
import './style.less'

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
        return (
          <div>
            测试
            <ul className="item-title">
              111
            </ul>
            <ul>111</ul>
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

class ListItem extends Component<ListItemProps> {
  createIcon = (icon: string) => {
    return <img src={logo} className="App-logo" alt="logo" />
  }

  createTitle = (title: string) => {
    return <ul>title</ul>
  }

  createSubTitle = (title: string) => {
    return <p>title</p>
  }

  render() {
    let { icon, title, subtitle } = this.props
    return (
      <div>
        {this.createIcon('123')}
        {!!title ? this.createTitle(title) : null}
      </div>
    )
  }
}

