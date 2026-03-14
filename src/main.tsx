import './patch-headers'
import React, { Component, ReactNode } from 'react'
import ReactDOM from 'react-dom/client'
import { Provider } from 'react-redux'
import { ThemeProvider, createTheme } from '@mui/material/styles'
import CssBaseline from '@mui/material/CssBaseline'
import { store } from './store'
import App from './App'

class ErrorBoundary extends Component<{ children: ReactNode }, { error: string | null }> {
  constructor(props: { children: ReactNode }) {
    super(props)
    this.state = { error: null }
  }
  componentDidCatch(error: Error) {
    this.setState({ error: error.message + '\n' + error.stack })
  }
  render() {
    if (this.state.error) {
      return (
        <div style={{ background: '#F7F8FA', color: '#FF4D4D', padding: 24, fontFamily: 'monospace', whiteSpace: 'pre-wrap', fontSize: 13 }}>
          {this.state.error}
        </div>
      )
    }
    return this.props.children
  }
}

const theme = createTheme({
  palette: {
    mode: 'light',
    background: {
      default: '#F7F8FA',
      paper: '#FFFFFF',
    },
    primary: {
      main: '#FF7A18',
      light: '#FFB347',
      dark: '#E05E00',
      contrastText: '#ffffff',
    },
    secondary: {
      main: '#FFB347',
      contrastText: '#ffffff',
    },
    success: { main: '#22C55E' },
    warning: { main: '#F59E0B' },
    info: { main: '#6366F1' },
    error: { main: '#FF4D4D' },
    text: {
      primary: '#1A1A1A',
      secondary: 'rgba(0,0,0,0.55)',
    },
    divider: '#E9E9E9',
  },
  typography: {
    fontFamily: "'Inter', -apple-system, BlinkMacSystemFont, sans-serif",
    h1: { fontWeight: 800, fontSize: '2rem', letterSpacing: '-0.03em' },
    h2: { fontWeight: 700, fontSize: '1.625rem', letterSpacing: '-0.02em' },
    h3: { fontWeight: 700, fontSize: '1.25rem', letterSpacing: '-0.01em' },
    h4: { fontWeight: 700, fontSize: '1.125rem', letterSpacing: '-0.01em' },
    h5: { fontWeight: 700, fontSize: '1rem' },
    h6: { fontWeight: 600, fontSize: '0.9375rem' },
    body1: { fontSize: '1rem', lineHeight: 1.6 },
    body2: { fontSize: '0.875rem', lineHeight: 1.55 },
    caption: { fontSize: '0.8125rem' },
  },
  shape: { borderRadius: 14 },
  components: {
    MuiCssBaseline: {
      styleOverrides: {
        body: {
          background: '#F7F8FA',
          scrollbarWidth: 'thin',
          scrollbarColor: 'rgba(0,0,0,0.1) transparent',
        },
        '*::-webkit-scrollbar': { width: '5px' },
        '*::-webkit-scrollbar-track': { background: 'transparent' },
        '*::-webkit-scrollbar-thumb': {
          background: 'rgba(0,0,0,0.12)',
          borderRadius: '3px',
        },
      },
    },
    MuiAppBar: {
      styleOverrides: {
        root: {
          background: '#FFFFFF',
          borderBottom: '1px solid #F0F0F0',
          boxShadow: 'none',
          color: '#1A1A1A',
        },
      },
    },
    MuiPaper: {
      styleOverrides: {
        root: {
          backgroundImage: 'none',
        },
        elevation1: {
          boxShadow: '0 2px 12px rgba(0,0,0,0.06)',
        },
        elevation2: {
          boxShadow: '0 4px 20px rgba(0,0,0,0.08)',
        },
        elevation3: {
          boxShadow: '0 10px 30px rgba(0,0,0,0.08)',
        },
        outlined: {
          border: '1px solid #E9E9E9',
        },
      },
    },
    MuiButton: {
      styleOverrides: {
        root: {
          borderRadius: 14,
          textTransform: 'none',
          fontWeight: 600,
          letterSpacing: '-0.01em',
          fontSize: '0.9375rem',
        },
        contained: {
          background: 'linear-gradient(135deg, #FF7A18 0%, #FFB347 100%)',
          boxShadow: '0 4px 16px rgba(255,122,24,0.3)',
          '&:hover': {
            background: 'linear-gradient(135deg, #E86A08 0%, #F0A030 100%)',
            boxShadow: '0 6px 22px rgba(255,122,24,0.4)',
          },
          '&.Mui-disabled': {
            background: '#E9E9E9',
            color: '#B0B0B0',
            boxShadow: 'none',
          },
        },
        outlined: {
          borderColor: '#E9E9E9',
          color: '#1A1A1A',
          '&:hover': {
            borderColor: '#FF7A18',
            color: '#FF7A18',
            background: 'rgba(255,122,24,0.04)',
          },
        },
        text: {
          color: '#1A1A1A',
          '&:hover': { background: 'rgba(0,0,0,0.04)' },
        },
      },
    },
    MuiChip: {
      styleOverrides: {
        root: {
          borderRadius: 20,
          fontWeight: 500,
          fontSize: '0.8125rem',
          height: 30,
        },
        outlined: { borderColor: '#E9E9E9' },
        filled: { background: '#F0F0F0' },
      },
    },
    MuiCard: {
      styleOverrides: {
        root: {
          backgroundImage: 'none',
          borderRadius: 20,
          boxShadow: '0 4px 20px rgba(0,0,0,0.08)',
          border: 'none',
        },
      },
    },
    MuiTextField: {
      styleOverrides: {
        root: {
          '& .MuiOutlinedInput-root': {
            borderRadius: 12,
            background: '#FFFFFF',
            fontSize: '0.9375rem',
            '& fieldset': { borderColor: '#E9E9E9' },
            '&:hover fieldset': { borderColor: '#C0C0C0' },
            '&.Mui-focused fieldset': { borderColor: '#FF7A18', borderWidth: 1.5 },
          },
          '& .MuiInputLabel-root.Mui-focused': { color: '#FF7A18' },
        },
      },
    },
    MuiSwitch: {
      styleOverrides: {
        root: {
          '& .MuiSwitch-switchBase.Mui-checked': { color: '#22C55E' },
          '& .MuiSwitch-switchBase.Mui-checked + .MuiSwitch-track': {
            backgroundColor: '#22C55E',
          },
        },
      },
    },
    MuiTabs: {
      styleOverrides: {
        root: { borderBottom: '1px solid #E9E9E9' },
        indicator: { backgroundColor: '#FF7A18', height: 2, borderRadius: 1 },
      },
    },
    MuiTab: {
      styleOverrides: {
        root: {
          textTransform: 'none',
          fontWeight: 500,
          fontSize: '0.9rem',
          color: 'rgba(0,0,0,0.5)',
          '&.Mui-selected': { color: '#FF7A18', fontWeight: 600 },
        },
      },
    },
    MuiAlert: {
      styleOverrides: {
        root: { borderRadius: 14, fontSize: '0.875rem' },
      },
    },
    MuiDivider: {
      styleOverrides: {
        root: { borderColor: '#F0F0F0' },
      },
    },
    MuiDialog: {
      styleOverrides: {
        paper: {
          borderRadius: 24,
          boxShadow: '0 24px 60px rgba(0,0,0,0.14)',
        },
      },
    },
    MuiListItem: {
      styleOverrides: {
        root: { borderRadius: 10 },
      },
    },
    MuiIconButton: {
      styleOverrides: {
        root: {
          borderRadius: 14,
          transition: 'transform 0.15s ease, box-shadow 0.15s ease',
        },
      },
    },
    MuiToggleButton: {
      styleOverrides: {
        root: {
          borderRadius: '10px !important',
          textTransform: 'none',
          fontWeight: 500,
          fontSize: '0.875rem',
          border: '1px solid #E9E9E9 !important',
          color: 'rgba(0,0,0,0.6)',
          '&.Mui-selected': {
            background: 'linear-gradient(135deg, #FF7A18 0%, #FFB347 100%) !important',
            color: '#fff !important',
            border: 'none !important',
          },
        },
      },
    },
    MuiAccordion: {
      styleOverrides: {
        root: {
          boxShadow: 'none',
          '&:before': { display: 'none' },
          borderRadius: '16px !important',
        },
      },
    },
  },
})

ReactDOM.createRoot(document.getElementById('root')!).render(
  <React.StrictMode>
    <ErrorBoundary>
      <Provider store={store}>
        <ThemeProvider theme={theme}>
          <CssBaseline />
          <App />
        </ThemeProvider>
      </Provider>
    </ErrorBoundary>
  </React.StrictMode>
)
