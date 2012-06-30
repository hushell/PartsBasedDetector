/* 
 *  Software License Agreement (BSD License)
 *
 *  Copyright (c) 2012, Willow Garage, Inc.
 *  All rights reserved.
 *
 *  Redistribution and use in source and binary forms, with or without
 *  modification, are permitted provided that the following conditions
 *  are met:
 *
 *   * Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above
 *     copyright notice, this list of conditions and the following
 *     disclaimer in the documentation and/or other materials provided
 *     with the distribution.
 *   * Neither the name of Willow Garage, Inc. nor the names of its
 *     contributors may be used to endorse or promote products derived
 *     from this software without specific prior written permission.
 *
 *  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 *  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 *  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 *  FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
 *  COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 *  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 *  BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 *  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 *  CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 *  LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
 *  ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 *  POSSIBILITY OF SUCH DAMAGE.
 *
 *  File:    DynamicProgram.hpp
 *  Author:  Hilton Bristow
 *  Created: Jun 21, 2012
 */

#ifndef DYNAMICPROGRAM_HPP_
#define DYNAMICPROGRAM_HPP_
#include <vector>
#include <opencv2/core/core.hpp>
#include "Candidate.hpp"
#include "Model.hpp"
#include "Part.hpp"

/*
 *
 */
class DynamicProgram {
private:
	//! the threshold for a positive detection
	double thresh_;
	void minRecursive(const Part& self, const Part& parent, std::vector<cv::Mat>& scores, int nparts, int scale);
	void distanceTransform1D(const float* src, float* dst, int* ptr, int n, float a, float b);
public:
	DynamicProgram();
	virtual ~DynamicProgram();
	// public methods
	void min(Part rootpart, std::vector<cv::Mat>& responses, int nscales);
	void argmin(std::vector<Candidate>& candidates);
	void distanceTransform(const cv::Mat& score_in, const std::vector<float> w, cv::Mat& score_out, cv::Mat& Ix, cv::Mat& Iy);
};

#endif /* DYNAMICPROGRAM_HPP_ */