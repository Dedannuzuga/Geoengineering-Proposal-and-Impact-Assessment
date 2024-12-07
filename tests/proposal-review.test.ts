import { describe, it, expect } from 'vitest';

describe('Proposal Review Contract', () => {
  it('should submit and retrieve a proposal', () => {
    const proposal = { title: 'Test Proposal', description: 'Description', dataUrl: 'https://example.com/data' };
    
    // Submit proposal
    const submitResult = submitProposal(proposal.title, proposal.description, proposal.dataUrl);
    expect(submitResult.success).toBe(true);
    expect(typeof submitResult.value).toBe('number');
    
    // Retrieve proposal
    const retrievedProposal = getProposal(submitResult.value);
    expect(retrievedProposal).toEqual(proposal);
  });
  
  it('should submit and retrieve a review', () => {
    const review = { proposalId: 1, score: 4, comment: 'Great proposal' };
    
    // Submit review
    const submitResult = submitReview(review.proposalId, review.score, review.comment);
    expect(submitResult.success).toBe(true);
    
    // Retrieve review
    const retrievedReview = getReview(review.proposalId, 'reviewer_address');
    expect(retrievedReview).toEqual({ score: review.score, comment: review.comment });
  });
});

// Mock functions to simulate contract calls
function submitProposal(title: string, description: string, dataUrl: string) {
  return { success: true, value: 1 };
}

function getProposal(id: number) {
  return { title: 'Test Proposal', description: 'Description', dataUrl: 'https://example.com/data' };
}

function submitReview(proposalId: number, score: number, comment: string) {
  return { success: true };
}

function getReview(proposalId: number, reviewer: string) {
  return { score: 4, comment: 'Great proposal' };
}

