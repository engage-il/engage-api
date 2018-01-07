// @flow
import { capitalize } from 'lodash'
import { primary, neutralShadow } from '../colors'

type BorderStyle = {
  borderTop?: string,
  borderBottom?: string,
  borderLeft?: string,
  borderRight?: string,
}

type BorderEdge
  = 'top'
  | 'bottom'
  | 'left'
  | 'right'

type BorderCreator
  = (edges?: Array<BorderEdge>) => BorderStyle

// creator
function borderCreator (color: string): BorderCreator {
  const border = `1px solid ${color}`

  return function (edges = ['top', 'bottom', 'left', 'right']) {
    return edges.reduce((memo, edge) => ({
      ...memo,
      [`border${capitalize(edge)}`]: border
    }), {})
  }
}

// exports
export const low = borderCreator(neutralShadow)
export const high = borderCreator(primary)
