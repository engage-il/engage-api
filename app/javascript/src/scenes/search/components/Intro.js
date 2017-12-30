// @flow
import * as React from 'react'
import FontAwesome from 'react-fontawesome'
import { css } from 'glamor'
import type { Rule } from 'glamor'
import { Link, Defer } from 'shared/components'
import { local } from 'shared/storage'
import { stylesheet, mixins } from 'shared/styles'

type Props = {
  styles?: Rule
}

type State = {
  isAccepted: boolean
}

export class Intro extends React.Component<*, Props, State> {
  state = {
    isAccepted: !!local.get('intro-cleared')
  }

  // events
  didClickAccept = () => {
    this.setState({ isAccepted: true }, () => {
      local.set('intro-cleared', 'true')
    })
  }

  // lifecycle
  componentDidMount () {
    local.set('intro-visited', 'true')
  }

  render () {
    if (this.state.isAccepted) {
      return null
    }

    const { styles } = this.props

    return (
      <Defer>
        <div {...css(rules.intro, styles)}>
          <h1>Hey, welcome to Legislated!</h1>
          <p>
            Never heard of a witness slip? As a resident of Illinois, it's a tool
            that allows you to voice your opinion on the laws your representatives
            write. Search for a bill you care about and let the legislature know
            how you feel. <strong>Want to learn more?</strong>
            <span {...rules.actionLinks}>
              <Link to='/faq'>Visit our FAQs</Link>
              <Link styles={rules.accept} onClick={this.didClickAccept}>
                <FontAwesome name='check' />
                <span>Got it.</span>
              </Link>
            </span>
          </p>
        </div>
      </Defer>
    )
  }
}

const rules = stylesheet({
  intro: {
    fontSize: 18,
    '> h1': {
      marginBottom: 15
    }
  },
  actionLinks: {
    marginLeft: 10,
    ...mixins.mobile.glam({
      display: 'block',
      marginTop: 10,
      marginLeft: 0
    })
  },
  accept: {
    ...mixins.borders.low(['left']),
    marginLeft: 10,
    paddingLeft: 10,
    '> *:last-child': {
      marginLeft: 5
    }
  }
})
