package com.voting.controller;

import com.voting.dto.VoteRequestDto;
import com.voting.model.Candidate;
import com.voting.model.Election;
import com.voting.model.User;
import com.voting.model.Vote;
import com.voting.service.CandidateService;
import com.voting.service.ElectionService;
import com.voting.service.UserService;
import com.voting.service.VotingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.*;

@Controller
@RequestMapping("/voter")
public class VoterController {

    @Autowired
    private UserService userService;

    @Autowired
    private ElectionService electionService;

    @Autowired
    private CandidateService candidateService;

    @Autowired
    private VotingService votingService;

    @GetMapping("/dashboard")
    public String dashboard(Authentication authentication, Model model) {
        String email = authentication.getName();
        User currentUser = userService.findByEmail(email).orElseThrow();

        List<Election> activeElections = electionService.getActiveElections();
        List<Vote> voterHistory = votingService.getVotesByUser(currentUser.getId());

        Set<Long> votedElectionIds = new HashSet<>();
        for (Vote v : voterHistory) {
            votedElectionIds.add(v.getElection().getId());
        }

        model.addAttribute("currentUser", currentUser);
        model.addAttribute("activeElections", activeElections);
        model.addAttribute("votedElectionIds", votedElectionIds);
        model.addAttribute("totalElections", electionService.getAllElections().size());
        model.addAttribute("votedCount", voterHistory.size());

        return "voter/dashboard";
    }

    @GetMapping("/elections")
    public String electionsList(Authentication authentication, Model model) {
        String email = authentication.getName();
        User currentUser = userService.findByEmail(email).orElseThrow();

        List<Election> allElections = electionService.getAllElections();
        List<Vote> voterHistory = votingService.getVotesByUser(currentUser.getId());

        Set<Long> votedElectionIds = new HashSet<>();
        for (Vote v : voterHistory) {
            votedElectionIds.add(v.getElection().getId());
        }

        model.addAttribute("currentUser", currentUser);
        model.addAttribute("allElections", allElections);
        model.addAttribute("votedElectionIds", votedElectionIds);

        return "voter/elections";
    }

    @GetMapping("/vote/{electionId}")
    public String voteBooth(@PathVariable("electionId") Long electionId, Authentication authentication, Model model, RedirectAttributes redirectAttributes) {
        String email = authentication.getName();
        User currentUser = userService.findByEmail(email).orElseThrow();

        Election election = electionService.getElectionById(electionId)
                .orElseThrow(() -> new IllegalArgumentException("Invalid Election ID"));

        if (votingService.hasUserVotedInElection(currentUser.getId(), electionId)) {
            redirectAttributes.addFlashAttribute("errorMessage", "You have already cast your vote in " + election.getTitle());
            return "redirect:/voter/history";
        }

        if (!"ACTIVE".equalsIgnoreCase(election.getStatus())) {
            redirectAttributes.addFlashAttribute("errorMessage", "Voting is closed for " + election.getTitle());
            return "redirect:/voter/elections";
        }

        List<Candidate> candidates = candidateService.getCandidatesByElection(electionId);

        model.addAttribute("currentUser", currentUser);
        model.addAttribute("election", election);
        model.addAttribute("candidates", candidates);
        model.addAttribute("voteRequest", new VoteRequestDto(electionId, null));

        return "voter/vote";
    }

    @PostMapping("/vote")
    public String submitVote(@ModelAttribute("voteRequest") VoteRequestDto voteRequest,
                             Authentication authentication,
                             RedirectAttributes redirectAttributes) {
        try {
            String email = authentication.getName();
            Vote vote = votingService.castVote(email, voteRequest.getElectionId(), voteRequest.getCandidateId());
            redirectAttributes.addFlashAttribute("successMessage",
                    "Success! Your vote for candidate '" + vote.getCandidate().getName() +
                    "' in '" + vote.getElection().getTitle() + "' has been securely recorded.");
            return "redirect:/voter/history";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
            return "redirect:/voter/elections";
        }
    }

    @GetMapping("/history")
    public String voteHistory(Authentication authentication, Model model) {
        String email = authentication.getName();
        User currentUser = userService.findByEmail(email).orElseThrow();

        List<Vote> votes = votingService.getVotesByUser(currentUser.getId());
        model.addAttribute("currentUser", currentUser);
        model.addAttribute("votes", votes);

        return "voter/history";
    }

    @GetMapping("/results/{electionId}")
    public String viewResults(@PathVariable("electionId") Long electionId, Authentication authentication, Model model) {
        String email = authentication.getName();
        User currentUser = userService.findByEmail(email).orElseThrow();

        Election election = electionService.getElectionById(electionId)
                .orElseThrow(() -> new IllegalArgumentException("Election not found: " + electionId));

        List<Candidate> sortedCandidates = candidateService.getCandidatesSortedByVotes(electionId);
        long totalVotes = votingService.getTotalVotesForElection(electionId);

        Candidate winner = null;
        if (!sortedCandidates.isEmpty() && totalVotes > 0) {
            winner = sortedCandidates.get(0);
        }

        boolean hasVoted = votingService.hasUserVotedInElection(currentUser.getId(), electionId);

        model.addAttribute("currentUser", currentUser);
        model.addAttribute("election", election);
        model.addAttribute("candidates", sortedCandidates);
        model.addAttribute("totalVotes", totalVotes);
        model.addAttribute("winner", winner);
        model.addAttribute("hasVoted", hasVoted);

        return "voter/results";
    }
}
