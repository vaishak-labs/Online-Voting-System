package com.voting.controller;

import com.voting.model.Candidate;
import com.voting.model.Election;
import com.voting.model.User;
import com.voting.service.CandidateService;
import com.voting.service.ElectionService;
import com.voting.service.UserService;
import com.voting.service.VotingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDateTime;
import java.util.List;

@Controller
@RequestMapping("/admin")
public class AdminController {

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

        List<Election> elections = electionService.getAllElections();
        List<User> voters = userService.getAllVoters();

        model.addAttribute("currentUser", currentUser);
        model.addAttribute("totalElections", elections.size());
        model.addAttribute("totalVoters", voters.size());
        model.addAttribute("activeElectionsCount", electionService.getActiveElections().size());
        model.addAttribute("recentElections", elections.stream().limit(5).toList());

        return "admin/dashboard";
    }

    @GetMapping("/elections")
    public String listElections(Model model) {
        model.addAttribute("elections", electionService.getAllElections());
        return "admin/elections";
    }

    @GetMapping("/elections/new")
    public String showCreateElectionForm(Model model) {
        model.addAttribute("election", new Election());
        return "admin/create-election";
    }

    @PostMapping("/elections/new")
    public String createElection(
            @RequestParam("title") String title,
            @RequestParam("description") String description,
            @RequestParam("category") String category,
            @RequestParam("startDate") @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime startDate,
            @RequestParam("endDate") @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime endDate,
            @RequestParam("status") String status,
            RedirectAttributes redirectAttributes) {

        Election election = new Election(title, description, category, startDate, endDate, status);
        electionService.createElection(election);
        redirectAttributes.addFlashAttribute("successMessage", "Election '" + title + "' successfully created!");
        return "redirect:/admin/elections";
    }

    @PostMapping("/elections/{id}/status")
    public String updateElectionStatus(@PathVariable("id") Long id, @RequestParam("status") String status, RedirectAttributes redirectAttributes) {
        electionService.updateElectionStatus(id, status);
        redirectAttributes.addFlashAttribute("successMessage", "Election status updated to " + status);
        return "redirect:/admin/elections";
    }

    @GetMapping("/elections/{id}/edit")
    public String showEditElectionForm(@PathVariable("id") Long id, Model model) {
        Election election = electionService.getElectionById(id)
                .orElseThrow(() -> new IllegalArgumentException("Election not found: " + id));
        model.addAttribute("election", election);
        return "admin/edit-election";
    }

    @PostMapping("/elections/{id}/edit")
    public String editElection(
            @PathVariable("id") Long id,
            @RequestParam("title") String title,
            @RequestParam("description") String description,
            @RequestParam("category") String category,
            @RequestParam("startDate") @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime startDate,
            @RequestParam("endDate") @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime endDate,
            @RequestParam("status") String status,
            RedirectAttributes redirectAttributes) {

        Election updated = new Election(title, description, category, startDate, endDate, status);
        electionService.updateElection(id, updated);
        redirectAttributes.addFlashAttribute("successMessage", "Election '" + title + "' updated successfully!");
        return "redirect:/admin/elections";
    }

    @PostMapping("/elections/{id}/delete")
    public String deleteElection(@PathVariable("id") Long id, RedirectAttributes redirectAttributes) {
        electionService.deleteElection(id);
        redirectAttributes.addFlashAttribute("successMessage", "Election and associated candidate/vote data deleted successfully.");
        return "redirect:/admin/elections";
    }

    @GetMapping("/candidates")
    public String listCandidates(@RequestParam(value = "electionId", required = false) Long electionId, Model model) {
        List<Election> elections = electionService.getAllElections();
        model.addAttribute("elections", elections);

        if (electionId != null) {
            model.addAttribute("selectedElectionId", electionId);
            model.addAttribute("candidates", candidateService.getCandidatesByElection(electionId));
        } else if (!elections.isEmpty()) {
            Long defaultId = elections.get(0).getId();
            model.addAttribute("selectedElectionId", defaultId);
            model.addAttribute("candidates", candidateService.getCandidatesByElection(defaultId));
        }

        return "admin/candidates";
    }

    @GetMapping("/candidates/new")
    public String showAddCandidateForm(@RequestParam(value = "electionId", required = false) Long electionId, Model model) {
        model.addAttribute("elections", electionService.getAllElections());
        model.addAttribute("selectedElectionId", electionId);
        model.addAttribute("candidate", new Candidate());
        return "admin/add-candidate";
    }

    @PostMapping("/candidates/new")
    public String addCandidate(
            @RequestParam("electionId") Long electionId,
            @RequestParam("name") String name,
            @RequestParam("party") String party,
            @RequestParam("symbolUrl") String symbolUrl,
            @RequestParam("bio") String bio,
            RedirectAttributes redirectAttributes) {

        Candidate candidate = new Candidate(null, name, party, symbolUrl, bio);
        candidateService.addCandidateToElection(electionId, candidate);
        redirectAttributes.addFlashAttribute("successMessage", "Candidate '" + name + "' added successfully!");
        return "redirect:/admin/candidates?electionId=" + electionId;
    }

    @GetMapping("/candidates/{id}/edit")
    public String showEditCandidateForm(@PathVariable("id") Long id, Model model) {
        Candidate candidate = candidateService.getCandidateById(id)
                .orElseThrow(() -> new IllegalArgumentException("Candidate not found: " + id));
        model.addAttribute("candidate", candidate);
        return "admin/edit-candidate";
    }

    @PostMapping("/candidates/{id}/edit")
    public String editCandidate(
            @PathVariable("id") Long id,
            @RequestParam("name") String name,
            @RequestParam("party") String party,
            @RequestParam("symbolUrl") String symbolUrl,
            @RequestParam("bio") String bio,
            RedirectAttributes redirectAttributes) {

        Candidate updated = new Candidate(null, name, party, symbolUrl, bio);
        Candidate candidate = candidateService.updateCandidate(id, updated);
        redirectAttributes.addFlashAttribute("successMessage", "Candidate profile for '" + name + "' updated successfully!");
        return "redirect:/admin/candidates?electionId=" + candidate.getElection().getId();
    }

    @PostMapping("/candidates/{id}/delete")
    public String deleteCandidate(@PathVariable("id") Long id, @RequestParam("electionId") Long electionId, RedirectAttributes redirectAttributes) {
        candidateService.deleteCandidate(id);
        redirectAttributes.addFlashAttribute("successMessage", "Candidate deleted successfully.");
        return "redirect:/admin/candidates?electionId=" + electionId;
    }

    @GetMapping("/results/{electionId}")
    public String viewResults(@PathVariable("electionId") Long electionId, Model model) {
        Election election = electionService.getElectionById(electionId)
                .orElseThrow(() -> new IllegalArgumentException("Election not found: " + electionId));

        List<Candidate> sortedCandidates = candidateService.getCandidatesSortedByVotes(electionId);
        long totalVotes = votingService.getTotalVotesForElection(electionId);

        Candidate winner = null;
        if (!sortedCandidates.isEmpty() && totalVotes > 0) {
            winner = sortedCandidates.get(0);
        }

        model.addAttribute("election", election);
        model.addAttribute("candidates", sortedCandidates);
        model.addAttribute("totalVotes", totalVotes);
        model.addAttribute("winner", winner);

        return "admin/results";
    }

    @GetMapping("/voters")
    public String listVoters(Model model) {
        model.addAttribute("voters", userService.getAllVoters());
        return "admin/voters";
    }

    @PostMapping("/voters/{userId}/toggle-verification")
    public String toggleVerification(@PathVariable("userId") Long userId, RedirectAttributes redirectAttributes) {
        userService.toggleVerification(userId);
        redirectAttributes.addFlashAttribute("successMessage", "Voter verification status updated.");
        return "redirect:/admin/voters";
    }

    @PostMapping("/voters/{userId}/delete")
    public String deleteVoter(@PathVariable("userId") Long userId, RedirectAttributes redirectAttributes) {
        try {
            userService.deleteVoter(userId);
            redirectAttributes.addFlashAttribute("successMessage", "Voter account removed successfully.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        }
        return "redirect:/admin/voters";
    }
}
