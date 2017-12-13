// @flow
export { default as addDays } from 'date-fns/add_days'
export { default as addHours } from 'date-fns/add_hours'
export { default as addMonths } from 'date-fns/add_months'
export { default as differenceInHours } from 'date-fns/difference_in_hours'
export { default as endOfDay } from 'date-fns/end_of_day'
export { default as formatDate } from 'date-fns/format'
export { default as parseDate } from 'date-fns/parse'
export { default as startOfDay } from 'date-fns/start_of_day'

export function now () {
  return new Date()
}
