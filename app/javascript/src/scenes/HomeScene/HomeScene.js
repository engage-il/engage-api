// @flow
import * as React from 'react'
import { createFragmentContainer, graphql } from 'react-relay'
import styled from 'react-emotion'
import { HomeIntro } from './HomeIntro'
import { BillSearch } from 'shared/components'
import type { Viewer } from 'shared/types'
import { mixins } from 'shared/styles'

type Props = {
  viewer: ?Viewer
}

let HomeScene = function HomeScene ({ viewer }: Props) {
  return (
    <Section>
      <HomeIntro />
      <BillSearch
        viewer={viewer}
      />
    </Section>
  )
}

HomeScene = createFragmentContainer(HomeScene, graphql`
  fragment HomeScene_viewer on Viewer {
    ...BillSearch_viewer
  }
`)

const Section = styled.section`
  ${mixins.flexColumn};
`

export { HomeScene }
