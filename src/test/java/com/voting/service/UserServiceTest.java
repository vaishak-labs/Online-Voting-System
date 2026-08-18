package com.voting.service;

import com.voting.dto.RegistrationDto;
import com.voting.model.User;
import com.voting.repository.UserRepository;
import com.voting.repository.VoteRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.security.crypto.password.PasswordEncoder;

import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class UserServiceTest {

    @Mock
    private UserRepository userRepository;

    @Mock
    private VoteRepository voteRepository;

    @Mock
    private PasswordEncoder passwordEncoder;

    @InjectMocks
    private UserService userService;

    private RegistrationDto validDto;

    @BeforeEach
    void setUp() {
        validDto = new RegistrationDto();
        validDto.setFullName("John Doe");
        validDto.setEmail("john@example.com");
        validDto.setPassword("password123");
        validDto.setConfirmPassword("password123");
    }

    @Test
    void registerVoter_Success() {
        when(userRepository.existsByEmail(validDto.getEmail())).thenReturn(false);
        when(passwordEncoder.encode(validDto.getPassword())).thenReturn("encodedPassword");
        when(userRepository.save(any(User.class))).thenAnswer(invocation -> invocation.getArgument(0));

        User registered = userService.registerVoter(validDto);

        assertNotNull(registered);
        assertEquals("John Doe", registered.getFullName());
        assertEquals("john@example.com", registered.getEmail());
        assertEquals("encodedPassword", registered.getPassword());
        assertTrue(registered.getVoterId().startsWith("VOT-"));
        assertTrue(registered.isVerified());
        assertEquals("ROLE_VOTER", registered.getRole());

        verify(userRepository, times(1)).save(any(User.class));
    }

    @Test
    void registerVoter_DuplicateEmail_ThrowsException() {
        when(userRepository.existsByEmail(validDto.getEmail())).thenReturn(true);

        IllegalArgumentException ex = assertThrows(IllegalArgumentException.class, () -> {
            userService.registerVoter(validDto);
        });

        assertEquals("Email address is already registered.", ex.getMessage());
        verify(userRepository, never()).save(any(User.class));
    }

    @Test
    void registerVoter_PasswordMismatch_ThrowsException() {
        validDto.setConfirmPassword("differentPassword");

        IllegalArgumentException ex = assertThrows(IllegalArgumentException.class, () -> {
            userService.registerVoter(validDto);
        });

        assertEquals("Password and confirm password do not match.", ex.getMessage());
        verify(userRepository, never()).save(any(User.class));
    }

    @Test
    void toggleVerification_Success() {
        User user = new User();
        user.setId(1L);
        user.setVerified(true);

        when(userRepository.findById(1L)).thenReturn(Optional.of(user));

        userService.toggleVerification(1L);

        assertFalse(user.isVerified());
        verify(userRepository, times(1)).save(user);
    }
}
