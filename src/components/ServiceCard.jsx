import { Box, Heading, Text, Icon, Link, VStack } from '@chakra-ui/react'
import { ExternalLinkIcon } from '@chakra-ui/icons'
import { motion } from 'framer-motion'

const MotionBox = motion(Box)

const ServiceCard = ({ title, description, url, icon, color, delay }) => {
  return (
    <MotionBox
      as={Link}
      href={url}
      isExternal
      textDecoration="none"
      _hover={{ textDecoration: 'none' }}
      initial={{ opacity: 0, scale: 0.8, y: 40 }}
      animate={{ opacity: 1, scale: 1, y: 0 }}
      transition={{
        duration: 0.7,
        delay,
        type: 'spring',
        stiffness: 100,
        damping: 15
      }}
      w={{ base: 'full', md: '280px', xl: '260px' }}
      maxW="320px"
    >
      <Box
        position="relative"
        h="full"
        minH={{ base: '280px', md: '320px' }}
        cursor="pointer"
        role="group"
      >
        {/* Main Card Container */}
        <Box
          bg="white"
          borderRadius="3xl"
          p={{ base: 8, md: 9 }}
          h="full"
          position="relative"
          overflow="hidden"
          boxShadow="0 20px 60px -15px rgba(0, 0, 0, 0.3)"
          transition="all 0.5s cubic-bezier(0.34, 1.56, 0.64, 1)"
          _groupHover={{
            transform: 'translateY(-16px) scale(1.05)',
            boxShadow: '0 30px 80px -10px rgba(0, 0, 0, 0.4)',
          }}
        >
          {/* Gradient Overlay Background */}
          <Box
            position="absolute"
            top={0}
            left={0}
            right={0}
            bottom={0}
            bgGradient={`linear(135deg, ${color}.50 0%, white 50%, ${color}.50 100%)`}
            opacity={0.6}
            transition="opacity 0.5s"
            _groupHover={{ opacity: 0.9 }}
          />

          {/* Animated Glow Effect */}
          <Box
            position="absolute"
            top="-50%"
            left="-50%"
            w="200%"
            h="200%"
            bgGradient={`radial(circle, ${color}.300 0%, transparent 70%)`}
            opacity={0}
            transition="all 0.6s"
            _groupHover={{
              opacity: 0.3,
              transform: 'rotate(45deg)',
            }}
          />

          {/* Top Accent Bar */}
          <Box
            position="absolute"
            top={0}
            left={0}
            right={0}
            h="8px"
            bgGradient={`linear(to-r, ${color}.400, ${color}.600, ${color}.400)`}
            borderTopRadius="3xl"
            _groupHover={{
              h: '12px',
            }}
            transition="all 0.4s"
          />

          {/* Content */}
          <VStack spacing={5} position="relative" zIndex={1} align="center" textAlign="center">
            {/* Icon Container with Floating Animation */}
            <MotionBox
              display="flex"
              alignItems="center"
              justifyContent="center"
              w={{ base: 20, md: 24 }}
              h={{ base: 20, md: 24 }}
              borderRadius="2xl"
              bgGradient={`linear(135deg, ${color}.400, ${color}.600)`}
              color="white"
              boxShadow={`0 15px 40px -12px var(--chakra-colors-${color}-500)`}
              position="relative"
              animate={{
                y: [0, -10, 0],
              }}
              transition={{
                duration: 3,
                repeat: Infinity,
                ease: "easeInOut"
              }}
              _groupHover={{
                boxShadow: `0 20px 60px -8px var(--chakra-colors-${color}-600)`,
              }}
              _before={{
                content: '""',
                position: 'absolute',
                inset: '-3px',
                borderRadius: '2xl',
                padding: '3px',
                background: `linear-gradient(135deg, ${color}.300, ${color}.500, ${color}.300)`,
                WebkitMask: 'linear-gradient(#fff 0 0) content-box, linear-gradient(#fff 0 0)',
                WebkitMaskComposite: 'xor',
                maskComposite: 'exclude',
                opacity: 0,
                transition: 'opacity 0.5s',
              }}
              sx={{
                '&:hover::before': {
                  opacity: 1,
                }
              }}
            >
              <Text fontSize={{ base: '4xl', md: '5xl' }} lineHeight="1">
                {icon}
              </Text>
            </MotionBox>

            {/* Title with Icon */}
            <VStack spacing={2} w="full">
              <Heading
                size={{ base: 'md', md: 'lg' }}
                color="gray.800"
                fontWeight="bold"
                letterSpacing="tight"
                lineHeight="shorter"
              >
                {title}
              </Heading>

              <Box
                display="inline-flex"
                alignItems="center"
                justifyContent="center"
                gap={1}
                px={3}
                py={1}
                borderRadius="full"
                bg={`${color}.100`}
                transition="all 0.3s"
                _groupHover={{
                  bg: `${color}.200`,
                  transform: 'scale(1.1)',
                }}
              >
                <Text fontSize="xs" color={`${color}.700`} fontWeight="semibold">
                  Buka Layanan
                </Text>
                <Icon
                  as={ExternalLinkIcon}
                  boxSize={3}
                  color={`${color}.700`}
                />
              </Box>
            </VStack>

            {/* Description */}
            <Text
              color="gray.600"
              fontSize="sm"
              lineHeight="1.6"
              noOfLines={3}
              fontWeight="medium"
            >
              {description}
            </Text>
          </VStack>

          {/* Bottom Decorative Elements */}
          <Box
            position="absolute"
            bottom={-16}
            right={-16}
            w={40}
            h={40}
            borderRadius="full"
            bgGradient={`radial(${color}.200 0%, ${color}.100 40%, transparent 70%)`}
            opacity={0.5}
            transition="all 0.5s"
            _groupHover={{
              transform: 'scale(1.3)',
              opacity: 0.7,
            }}
          />

          <Box
            position="absolute"
            top={-10}
            left={-10}
            w={32}
            h={32}
            borderRadius="full"
            bgGradient={`radial(${color}.100 0%, transparent 70%)`}
            opacity={0.4}
            transition="all 0.5s"
            _groupHover={{
              transform: 'scale(1.4)',
              opacity: 0.6,
            }}
          />
        </Box>

        {/* Outer Shadow Ring */}
        <Box
          position="absolute"
          top={-2}
          left={-2}
          right={-2}
          bottom={-2}
          borderRadius="3xl"
          border="3px solid"
          borderColor={`${color}.200`}
          opacity={0}
          transition="opacity 0.4s"
          _groupHover={{ opacity: 1 }}
          pointerEvents="none"
        />
      </Box>
    </MotionBox>
  )
}

export default ServiceCard
