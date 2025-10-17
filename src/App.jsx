import {
  Box,
  Container,
  Heading,
  Text,
  SimpleGrid,
  VStack,
  Image,
} from '@chakra-ui/react'
import { motion } from 'framer-motion'
import ServiceCard from './components/ServiceCard'

const MotionBox = motion(Box)
const MotionHeading = motion(Heading)
const MotionText = motion(Text)
const MotionImage = motion(Image)

function App() {
  const services = [
    {
      title: 'BIRO PBJ',
      description: 'Portal resmi Biro Pengadaan Barang dan Jasa Pemerintah Provinsi Kalimantan Barat',
      url: 'https://pbj.kalbarprov.go.id',
      icon: '📋',
      color: 'blue',
    },
    {
      title: 'LPSE',
      description: 'Layanan Pengadaan Secara Elektronik Kalimantan Barat melalui platform INAPROC',
      url: 'https://spse.inaproc.id/kalbarprov',
      icon: '🌐',
      color: 'green',
    },
    {
      title: 'SIPRAJA',
      description: 'Sistem Informasi Pengadaan Barang dan Jasa (Review Paket)',
      url: 'https://sipraja.kalbarprov.go.id',
      icon: '🏛️',
      color: 'purple',
    },
    {
      title: 'SIP-SPSE',
      description: 'Sistem Informasi Pelaporan Pengadaan Barang dan Jasa Secara Elektronik',
      url: 'https://sip-spse.kalbarprov.go.id',
      icon: '💼',
      color: 'teal',
    },
    {
      title: 'VMS',
      description: 'Visitor Management System',
      url: 'https://vms.kalbarprov.go.id',
      icon: '👥',
      color: 'orange',
    },
  ]

  return (
    <Box minH="100vh" py={{ base: 8, md: 12 }} px={{ base: 4, md: 8 }}>
      <Container maxW="container.2xl">
        <VStack spacing={{ base: 6, md: 8 }} mb={{ base: 12, md: 20 }}>
          {/* Header */}
          {/* Logo Kalimantan Barat */}
          <MotionImage
            src="/logo-kalbar.png"
            alt="Logo Provinsi Kalimantan Barat"
            boxSize={{ base: '80px', md: '120px', lg: '150px' }}
            objectFit="contain"
            initial={{ opacity: 0, scale: 0.8 }}
            animate={{ opacity: 1, scale: 1 }}
            transition={{ duration: 0.8 }}
            filter="drop-shadow(0 4px 12px rgba(0,0,0,0.3))"
          />

          <MotionHeading
            as="h1"
            fontSize={{ base: '2xl', sm: '3xl', md: '4xl', lg: '5xl' }}
            textAlign="center"
            color="white"
            fontWeight="black"
            lineHeight="1.2"
            letterSpacing="wide"
            maxW="6xl"
            initial={{ opacity: 0, y: -30 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.8, delay: 0.2 }}
            textShadow="0 6px 20px rgba(0,0,0,0.4), 0 2px 8px rgba(0,0,0,0.3)"
          >
            Portal Layanan Digital
          </MotionHeading>

          <MotionText
            fontSize={{ base: 'lg', md: 'xl', lg: '2xl' }}
            textAlign="center"
            color="white"
            fontWeight="bold"
            lineHeight="1.3"
            maxW="5xl"
            initial={{ opacity: 0, y: -20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.8, delay: 0.4 }}
            textShadow="0 4px 12px rgba(0,0,0,0.3)"
          >
            Biro Pengadaan Barang dan Jasa
          </MotionText>

          <MotionText
            fontSize={{ base: 'md', md: 'lg', lg: 'xl' }}
            textAlign="center"
            color="whiteAlpha.900"
            fontWeight="semibold"
            lineHeight="1.3"
            initial={{ opacity: 0, y: -10 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.8, delay: 0.6 }}
            textShadow="0 2px 8px rgba(0,0,0,0.3)"
          >
            Setda Provinsi Kalimantan Barat
          </MotionText>

          <MotionBox
            w={{ base: '100px', md: '140px' }}
            h="5px"
            bgGradient="linear(to-r, cyan.300, blue.400, purple.500, pink.400)"
            borderRadius="full"
            boxShadow="0 4px 20px rgba(99, 179, 237, 0.5)"
            initial={{ opacity: 0, scaleX: 0 }}
            animate={{ opacity: 1, scaleX: 1 }}
            transition={{ duration: 1, delay: 0.8 }}
          />

          <MotionText
            fontSize={{ base: 'sm', md: 'md' }}
            textAlign="center"
            color="whiteAlpha.800"
            fontWeight="medium"
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            transition={{ duration: 0.8, delay: 1.0 }}
            px={4}
          >
            Silakan pilih layanan yang ingin Anda akses
          </MotionText>
        </VStack>

        {/* Services Grid */}
        <SimpleGrid
          columns={{ base: 1, md: 2, xl: 5 }}
          spacing={{ base: 6, md: 8 }}
          mb={16}
          justifyItems="center"
        >
          {services.map((service, index) => (
            <ServiceCard
              key={index}
              {...service}
              delay={0.15 * (index + 1)}
            />
          ))}
        </SimpleGrid>

        {/* Footer */}
        <MotionBox
          textAlign="center"
          color="whiteAlpha.800"
          fontSize="sm"
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          transition={{ duration: 0.6, delay: 0.8 }}
        >
          <Text>
            &copy; {new Date().getFullYear()} Pemerintah Provinsi Kalimantan Barat
          </Text>
          <Text mt={1} fontSize="xs" color="whiteAlpha.600">
            Semua hak dilindungi undang-undang
          </Text>
        </MotionBox>
      </Container>
    </Box>
  )
}

export default App
