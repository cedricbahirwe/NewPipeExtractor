//
//  CommentsInfoItemsCollector.swift
//  NewPipeExtractor
//
//  Created by Cédric Bahirwe on 19/11/2024.
//


import Foundation

final class CommentsInfoItemsCollector<E: CommentsInfoItemExtractor>: InfoItemsCollector<CommentsInfoItem, E> {

    override init(serviceId: Int) {
        super.init(serviceId: serviceId)
    }

    override func extract(extractor: E) throws -> CommentsInfoItem {
        let resultItem = CommentsInfoItem(serviceId: getServiceId(), url: try extractor.getUrl(), name: try extractor.getName())
        
        // optional information
        do {
            resultItem.setCommentId(try extractor.getCommentId())
        } catch {
            addError(error)
        }
        
        do {
            resultItem.setCommentText(try extractor.getCommentText())
        } catch {
            addError(error)
        }
        
        do {
            resultItem.setUploaderName(try extractor.getUploaderName())
        } catch {
            addError(error)
        }
        
        do {
            resultItem.setUploaderAvatars(try extractor.getUploaderAvatars())
        } catch {
            addError(error)
        }
        
        do {
            resultItem.setUploaderUrl(try extractor.getUploaderUrl())
        } catch {
            addError(error)
        }
        
        do {
            resultItem.setTextualUploadDate(try extractor.getTextualUploadDate())
        } catch {
            addError(error)
        }
        
        do {
            resultItem.setUploadDate(try extractor.getUploadDate())
        } catch {
            addError(error)
        }
        
        do {
            resultItem.setLikeCount(try extractor.getLikeCount())
        } catch {
            addError(error)
        }
        
        do {
            resultItem.setTextualLikeCount(try extractor.getTextualLikeCount())
        } catch {
            addError(error)
        }
        
        do {
            resultItem.setThumbnails(try extractor.getThumbnails())
        } catch {
            addError(error)
        }
        
        do {
            resultItem.setHeartedByUploader(try extractor.isHeartedByUploader())
        } catch {
            addError(error)
        }
        
        do {
            resultItem.setPinned(try extractor.isPinned())
        } catch {
            addError(error)
        }
        
        do {
            resultItem.setStreamPosition(try extractor.getStreamPosition())
        } catch {
            addError(error)
        }
        
        do {
            resultItem.setReplyCount(try extractor.getReplyCount())
        } catch {
            addError(error)
        }
        
        do {
            resultItem.setReplies(try extractor.getReplies())
        } catch {
            addError(error)
        }
        
        do {
            resultItem.setChannelOwner(try extractor.isChannelOwner())
        } catch {
            addError(error)
        }
        
        do {
            resultItem.setCreatorReply(try extractor.hasCreatorReply())
        } catch {
            addError(error)
        }
        
        return resultItem
    }

    override func commit(extractor: E) {
        do {
            addItem(try extract(extractor: extractor))
        } catch {
            addError(error)
        }
    }
    
    func getCommentsInfoItemList() -> [CommentsInfoItem] {
        return getItems()
    }
}
