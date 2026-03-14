import { createContext, useContext } from 'react'

interface ModalContextValue {
  openAuth: () => void
  openPaywall: (reason?: string) => void
}

export const ModalContext = createContext<ModalContextValue>({
  openAuth: () => {},
  openPaywall: () => {},
})

export function useModalContext() {
  return useContext(ModalContext)
}
