// @flow
import * as React from 'react'
import { withRouter } from 'react-router-dom'
import styled from 'react-emotion'
import type { ContextRouter } from 'react-router-dom'
import { Header } from './Header'
import { MobileHeader, MOBILE_HEADER_HEIGHT } from './MobileHeader'
import { NotificationView } from '@/components'
import { mixins } from '@/styles'
import { local } from '@/storage'

type Props = {
  children?: any
} & ContextRouter

let Layout = class Layout extends React.Component<*, Props, *> {
  // actions
  clearVisitedIntro () {
    // mark the intro as cleared if we've seen it and left the search scene
    const { location } = this.props
    if (local.get('intro-visited') && location.pathname !== '/') {
      local.set('intro-cleared', 'true')
    }
  }

  // lifecycle
  componentDidMount () {
    this.clearVisitedIntro()
  }

  componentDidUpdate () {
    this.clearVisitedIntro()
  }

  render () {
    const { children } = this.props

    return (
      <Container>
        <Header />
        <MobileHeader />
        <Content>
          {children}
          <NotificationView />
        </Content>
      </Container>
    )
  }
}

const Container = styled.div`
  ${mixins.flexColumn};

  position: relative;
  min-height: 100vh;
`

const Content = styled.div`
  flex: 1;

  ${mixins.mobile`
    margin-top: ${MOBILE_HEADER_HEIGHT}px;
    padding: 15px;
    padding-bottom: 25px;
  `}
`

Layout = withRouter(Layout)

export { Layout }
